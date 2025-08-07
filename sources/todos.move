module todos::sui_workshop_todos;

use std::string::String;
use sui::vec_map::{Self, VecMap};
use sui::types;
use todos::errors;

// We need to have a TODOs collection
// We need an struct for a TODO
// We need some sort of Witness for auth <- Pending...

public struct TodoRegistry has key {
  id: UID,
  idx: u64,
  todos_map: VecMap<u64,Todo>,
  owner: address,
}

public struct Todo has store, copy, drop { 
    idx: u64,
    title: String,
    completed: bool,
    // created_at: u64,
    // updated_at: Option<u64>,
}

public struct SUI_WORKSHOP_TODOS() has drop;

// Pending implementaiton
public struct AdminWitness<phantom T>()


fun init(otw: SUI_WORKSHOP_TODOS, ctx: &mut TxContext){
  let reg = new(otw,ctx);
// The registry becomes public
  transfer::share_object(reg)
} 

// Check if the sender is the owner of the registry <- Pending, replace by checking an admin witness
fun isOwner(reg: &TodoRegistry, ctx: &TxContext) {
  assert!(ctx.sender() == reg.owner, errors::unauthorized!())
}

// Create registry only if the otw is valid
public fun new(otw: SUI_WORKSHOP_TODOS, ctx: &mut TxContext): TodoRegistry {
  assert!(types::is_one_time_witness(&otw), errors::invalid_otw!());
  TodoRegistry {
    id: object::new(ctx),
    idx: 0,
    todos_map: vec_map::empty(),
    owner: ctx.sender()
  }
}

// Registry methods
public fun get_todos(reg: &TodoRegistry): vector<Todo> {
  let (_, values) = reg.todos_map.into_keys_values();
  values
}
public fun get_todos_count(reg: &TodoRegistry): u64 {
  reg.todos_map.size()
}
public fun get_todo(reg: &TodoRegistry, idx: u64, ctx: &mut TxContext): Todo {
  isOwner(reg, ctx);
  assert!(idx < reg.idx, errors::todo_not_found!());
  assert!(reg.todos_map.contains(&idx), errors::todo_not_found!());
  *reg.todos_map.get(&idx)
}
public fun get_todo_mut(
  reg: &mut TodoRegistry,
  idx: u64, 
  ctx: &mut TxContext
): &mut Todo {
  isOwner(reg,ctx);
  assert!(idx < reg.idx, errors::todo_not_found!());
  assert!(reg.todos_map.contains(&idx), errors::todo_not_found!());
  let mutref = reg.todos_map.get_mut(&idx);
  mutref
}

// Mutative functions
public fun get_todo_and_amend(reg: &mut TodoRegistry, idx: u64, title: String, ctx: &mut TxContext) {
  let todo = get_todo_mut(reg, idx, ctx);
  todo.amend_todo(title)
}
public fun get_todo_and_update_status(reg: &mut TodoRegistry, idx: u64, status: bool, ctx: &mut TxContext) {
  let todo = get_todo_mut(reg, idx, ctx);
  if (status == true) {
    todo.mark_todo_as_completed();
  } else {
    todo.mark_todo_as_incomplete();
  }
}
public fun get_todo_and_delete(reg: &mut TodoRegistry, idx: u64, ctx: &mut TxContext){
  isOwner(reg,ctx);
  assert!(reg.todos_map.contains(&idx), errors::todo_not_found!());
  reg.todos_map.remove(&idx);
}

// Individual Todo methods
public fun create_todo(reg: &mut TodoRegistry, title: String, ctx: &mut TxContext): &Todo {
  isOwner(reg,ctx);
  reg.idx = reg.idx + 1;
  let todo = Todo {
    idx: reg.idx,
    title,
    completed: false,
  };
  reg.todos_map.insert(reg.idx, move todo);
  reg.todos_map.get(&reg.idx)
} 

public(package) fun amend_todo(self: &mut Todo, title: String){
  self.title = title;
}
public(package) fun mark_todo_as_completed(self: &mut Todo) {
  assert!(self.completed == true, errors::todo_already_completed!());
  self.completed = true;
}
public(package) fun mark_todo_as_incomplete(self: &mut Todo){
  self.completed = false;
}

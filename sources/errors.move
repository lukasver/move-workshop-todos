module todos::errors;

#[test_only]
const ETodoNotFound: u64 = 0;
#[test_only]
const ETodoAlreadyCompleted: u64 = 1;

public(package) macro fun invalid_otw(): u64 {
  0
}

public(package) macro fun unauthorized(): u64 {
  1
}

public(package) macro fun todo_not_found(): u64 {
  2
}

// public fn available only to the modules in this pkg. Macro makes its body inlined at compile time, removing the fn call overhead.
public(package) macro fun todo_already_completed(): u64 {
  3
}




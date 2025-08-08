
#[test_only]
module todos::todos_tests;
// uncomment this line to import the module
use todos::sui_workshop_todos as td;


use std::type_name;
use sui::{
    balance,
    sui::SUI,
    test_scenario::{Self as ts, Scenario},
    test_utils::{assert_eq, destroy}
};

const ENotImplemented: u64 = 0;

const ADMIN: address = @0x1;

#[test]
fun create_registry() {
  start()
}

// #[test, expected_failure(abort_code = ::todos::todos_tests::ENotImplemented)]
// fun test_todos_fail() {
//     abort ENotImplemented
// }

public struct World {
    scenario: Scenario,
}


fun start(): World {
    let mut scenario = ts::begin(ADMIN);

    scenario.next_tx(ADMIN);


    World { scenario }
}

fun end(world: World) {
    destroy(world);
}

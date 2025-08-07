
#[test_only]
module todos::todos_tests;
// uncomment this line to import the module
use todos::sui_workshop_todos as td;

const ENotImplemented: u64 = 0;

#[test]
fun create_registry() {
}

// #[test, expected_failure(abort_code = ::todos::todos_tests::ENotImplemented)]
// fun test_todos_fail() {
//     abort ENotImplemented
// }


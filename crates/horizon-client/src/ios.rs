//! iOS FFI bridge: functions Swift calls to start Horizon and inject input.
//! Compiled only on iOS.

#[unsafe(no_mangle)]
pub extern "C" fn start_ios() {
    let _ = crate::game::run();
}

#[unsafe(no_mangle)]
pub extern "C" fn ios_inject_key(_keycode: u32, _pressed: bool) {
    // Stub for now; wired up next commit once the build is green.
}
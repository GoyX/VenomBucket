use std::sync::atomic::{AtomicU32, Ordering};

pub static IOS_KEYS: AtomicU32 = AtomicU32::new(0);

#[unsafe(no_mangle)]
pub extern "C" fn start_ios() {
    let _ = crate::game::run();
}

#[unsafe(no_mangle)]
pub extern "C" fn ios_inject_key(keycode: u32, pressed: bool) {
    if pressed {
        IOS_KEYS.fetch_or(1 << keycode, Ordering::SeqCst);
    } else {
        IOS_KEYS.fetch_and(!(1 << keycode), Ordering::SeqCst);
    }
}
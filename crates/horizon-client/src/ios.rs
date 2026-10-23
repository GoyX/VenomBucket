use std::sync::atomic::{AtomicBool, AtomicI32, Ordering};

pub static KEY_W: AtomicBool = AtomicBool::new(false);
pub static KEY_A: AtomicBool = AtomicBool::new(false);
pub static KEY_S: AtomicBool = AtomicBool::new(false);
pub static KEY_D: AtomicBool = AtomicBool::new(false);
pub static KEY_SPACE: AtomicBool = AtomicBool::new(false);
pub static KEY_SHIFT: AtomicBool = AtomicBool::new(false);

pub static MOUSE_DX: AtomicI32 = AtomicI32::new(0);
pub static MOUSE_DY: AtomicI32 = AtomicI32::new(0);

#[unsafe(no_mangle)]
pub extern "C" fn start_ios() {
    let _ = crate::game::run();
}

#[unsafe(no_mangle)]
pub extern "C" fn ios_inject_key(keycode: u32, pressed: bool) {
    match keycode {
        0 => KEY_W.store(pressed, Ordering::Relaxed),
        1 => KEY_A.store(pressed, Ordering::Relaxed),
        2 => KEY_S.store(pressed, Ordering::Relaxed),
        3 => KEY_D.store(pressed, Ordering::Relaxed),
        4 => KEY_SPACE.store(pressed, Ordering::Relaxed),
        5 => KEY_SHIFT.store(pressed, Ordering::Relaxed),
        _ => {}
    }
}

#[unsafe(no_mangle)]
pub extern "C" fn ios_inject_mouse_motion(dx: f32, dy: f32) {
    MOUSE_DX.fetch_add((dx * 2.0) as i32, Ordering::Relaxed);
    MOUSE_DY.fetch_add((dy * 2.0) as i32, Ordering::Relaxed);
}
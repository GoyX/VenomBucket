//! Horizon: native Rust client for Minecraft Java Edition 26.3 gameplay.
#![cfg_attr(not(target_os = "ios"), forbid(unsafe_code))]

use horizon_client::{crash, logging};

fn main() {
    horizon_client::telemetry::mark_start();
    let args: Vec<String> = std::env::args().skip(1).collect();
    let game_args = args.iter().take_while(|a| *a != "--dedicated");
    let help = game_args.clone().any(|a| a == "--help" || a == "-h");

    let root_dir = if cfg!(target_os = "ios") {
        std::path::PathBuf::from(std::env::var("HOME").unwrap_or_else(|_| ".".into()))
            .join("Documents")
    } else {
        std::env::current_dir().unwrap_or_default()
    };
    let _ = std::fs::create_dir_all(&root_dir);

    let (home, side, thread) = if args.iter().any(|a| a == "--dedicated") {
        (root_dir.clone(), "server", "Server thread")
    } else {
        (root_dir.clone(), "client", "Render thread")
    };

    if !help {
        logging::init(&home, thread);
        crash::install(home.clone(), side);
    }

    if let Err(error) = horizon_client::game::run() {
        log::error!("Horizon: {error}");
        if !help {
            crash::report_error(&home, side, &*error);
        }
        #[cfg(windows)]
        if std::io::IsTerminal::is_terminal(&std::io::stdin()) {
            eprintln!("Press Enter to close.");
            let _ = std::io::stdin().read_line(&mut String::new());
        }
        #[cfg(not(target_os = "ios"))]
        std::process::exit(1);
    }
    logging::flush();
}
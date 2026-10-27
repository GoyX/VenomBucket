fn main() {
    horizon_client::telemetry::mark_start();

    // FIX: Set working directory to iOS Documents before anything else
    #[cfg(target_os = "ios")]
    {
        let home = std::env::var("HOME").unwrap_or_default();
        let documents = std::path::PathBuf::from(home).join("Documents");
        let _ = std::fs::create_dir_all(&documents);
        let _ = std::env::set_current_dir(&documents);
    }

    let args: Vec<String> = std::env::args().skip(1).collect();
    let game_args = args.iter().take_while(|a| *a != "--dedicated");
    let help = game_args.clone().any(|a| a == "--help" || a == "-h");
    
    let (home, side, thread) = if args.iter().any(|a| a == "--dedicated") {
        (std::path::PathBuf::from("."), "server", "Server thread")
    } else {
        (logging::game_home(), "client", "Render thread")
    };
    
    if !help {
        logging::init(&home, thread);
        crash::install(home.clone(), side);
    }
    
    if let Err(error) = game::run() {
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

    // FIX: Force iOS to exit when the game loop ends
    #[cfg(target_os = "ios")]
    {
        std::process::exit(0);
    }
}
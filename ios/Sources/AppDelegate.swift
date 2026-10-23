import UIKit

@_silgen_name("start_ios")
func start_ios()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var overlayWindow: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 1. Create the touch overlay window
        overlayWindow = UIWindow(frame: UIScreen.main.bounds)
        overlayWindow?.windowLevel = .alert + 1 // Keeps it on top of the game
        overlayWindow?.backgroundColor = .clear
        overlayWindow?.rootViewController = GameViewController()
        overlayWindow?.isHidden = false

        // 2. Start Rust on the MAIN thread (fixes the instant crash)
        start_ios()
        
        return true
    }
}
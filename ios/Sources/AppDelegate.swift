import UIKit

@_silgen_name("start_ios")
func start_ios()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var gameVC: GameViewController?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        gameVC = GameViewController()
        window?.rootViewController = gameVC
        window?.makeKeyAndVisible()

        DispatchQueue.global(qos: .userInteractive).async {
            start_ios()
        }

        return true
    }
}
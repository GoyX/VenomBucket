import UIKit

@_silgen_name("start_ios")
func start_ios()

DispatchQueue.main.async {
    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
        let overlayWindow = UIWindow(frame: UIScreen.main.bounds)
        overlayWindow.windowLevel = .alert + 1
        overlayWindow.backgroundColor = .clear
        overlayWindow.rootViewController = GameViewController()
        overlayWindow.isHidden = false
        objc_setAssociatedObject(UIApplication.shared, "overlayWindow", overlayWindow, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

start_ios()
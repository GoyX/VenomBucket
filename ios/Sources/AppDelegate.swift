import UIKit

@_silgen_name("start_ios")
func start_ios()

// Setup the overlay window synchronously
let overlayWindow = UIWindow(frame: UIScreen.main.bounds)
overlayWindow.windowLevel = .alert + 1
overlayWindow.backgroundColor = .clear
overlayWindow.rootViewController = GameViewController()
overlayWindow.isHidden = false

// Start the game on the main thread
start_ios()
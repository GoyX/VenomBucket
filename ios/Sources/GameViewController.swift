import UIKit

@_silgen_name("ios_inject_key")
func ios_inject_key(keycode: UInt32, pressed: Bool)

class GameViewController: UIViewController {
    let joystickBase = UIView()
    let joystickKnob = UIView()
    var joystickCenter = CGPoint.zero
    
    let jumpButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isMultipleTouchEnabled = true
        
        let size: CGFloat = 120
        let margin: CGFloat = 50
        joystickBase.frame = CGRect(x: margin, y: view.bounds.height - size - margin, width: size, height: size)
        joystickBase.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        joystickBase.layer.cornerRadius = size / 2
        view.addSubview(joystickBase)
        
        let knobSize: CGFloat = 50
        joystickKnob.frame = CGRect(x: (size - knobSize)/2, y: (size - knobSize)/2, width: knobSize, height: knobSize)
        joystickKnob.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        joystickKnob.layer.cornerRadius = knobSize / 2
        joystickBase.addSubview(joystickKnob)
        
        joystickCenter = CGPoint(x: joystickBase.bounds.midX, y: joystickBase.bounds.midY)
        
        let btnSize: CGFloat = 60
        jumpButton.frame = CGRect(x: view.bounds.width - btnSize - margin, y: view.bounds.height - btnSize - margin, width: btnSize, height: btnSize)
        jumpButton.setTitle("Jump", for: .normal)
        jumpButton.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        jumpButton.layer.cornerRadius = 8
        jumpButton.addTarget(self, action: #selector(jumpPressed), for: .touchDown)
        jumpButton.addTarget(self, action: #selector(jumpReleased), for: [.touchUpInside, .touchUpOutside])
        view.addSubview(jumpButton)
    }
    
    @objc func jumpPressed() { ios_inject_key(keycode: 4, pressed: true) }
    @objc func jumpReleased() { ios_inject_key(keycode: 4, pressed: false) }
    
    var leftTouch: UITouch?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: view)
            if joystickBase.frame.contains(loc) && leftTouch == nil {
                leftTouch = touch
                updateJoystick(touch)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = leftTouch, touches.contains(touch) {
            updateJoystick(touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = leftTouch, touches.contains(touch) {
            leftTouch = nil
            joystickKnob.center = joystickCenter
            ios_inject_key(keycode: 0, pressed: false)
            ios_inject_key(keycode: 1, pressed: false)
            ios_inject_key(keycode: 2, pressed: false)
            ios_inject_key(keycode: 3, pressed: false)
        }
    }
    
    func updateJoystick(_ touch: UITouch) {
        let loc = touch.location(in: joystickBase)
        let dx = loc.x - joystickCenter.x
        let dy = loc.y - joystickCenter.y
        let distance = sqrt(dx*dx + dy*dy)
        let maxDist = joystickBase.bounds.width / 2
        let clampedX = distance > maxDist ? dx / distance * maxDist : dx
        let clampedY = distance > maxDist ? dy / distance * maxDist : dy
        joystickKnob.center = CGPoint(x: joystickCenter.x + clampedX, y: joystickCenter.y + clampedY)
        
        ios_inject_key(keycode: 0, pressed: clampedY < -20) // W
        ios_inject_key(keycode: 2, pressed: clampedY > 20)  // S
        ios_inject_key(keycode: 1, pressed: clampedX < -20) // A
        ios_inject_key(keycode: 3, pressed: clampedX > 20)  // D
    }
}
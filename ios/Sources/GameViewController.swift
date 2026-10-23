import UIKit

@_silgen_name("ios_inject_key")
func ios_inject_key(keycode: UInt32, pressed: Bool)

@_silgen_name("ios_inject_mouse_motion")
func ios_inject_mouse_motion(dx: Float, dy: Float)

@_silgen_name("ios_inject_mouse_button")
func ios_inject_mouse_button(button: Int32, pressed: Bool)

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isMultipleTouchEnabled = true
        
        setupDpad()
        setupActionButtons()
    }
    
    func createButton(title: String, frame: CGRect, color: UIColor = UIColor(white: 1.0, alpha: 0.3)) -> UIButton {
        let btn = UIButton(type: .system)
        btn.frame = frame
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = color
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.isMultipleTouchEnabled = true
        view.addSubview(btn)
        return btn
    }
    
    func setupDpad() {
        let size: CGFloat = 60
        let margin: CGFloat = 30
        let startY = view.bounds.height - (size * 3) - margin
        
        let up = createButton(title: "▲", frame: CGRect(x: margin + size, y: startY, width: size, height: size))
        up.addTarget(self, action: #selector(keyW(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        
        let down = createButton(title: "▼", frame: CGRect(x: margin + size, y: startY + size * 2, width: size, height: size))
        down.addTarget(self, action: #selector(keyS(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        
        let left = createButton(title: "◀", frame: CGRect(x: margin, y: startY + size, width: size, height: size))
        left.addTarget(self, action: #selector(keyA(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        
        let right = createButton(title: "▶", frame: CGRect(x: margin + size * 2, y: startY + size, width: size, height: size))
        right.addTarget(self, action: #selector(keyD(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
    }
    
    func setupActionButtons() {
        let size: CGFloat = 55
        let margin: CGFloat = 30
        let rightX = view.bounds.width - size - margin
        let bottomY = view.bounds.height - size - margin
        
        // Bottom Right: Break / Place
        let breakBtn = createButton(title: "Break", frame: CGRect(x: rightX - size * 2 - 10, y: bottomY, width: size, height: size), color: UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 0.5))
        breakBtn.addTarget(self, action: #selector(mouseLeft(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        
        let placeBtn = createButton(title: "Place", frame: CGRect(x: rightX, y: bottomY, width: size, height: size), color: UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 0.5))
        placeBtn.addTarget(self, action: #selector(mouseRight(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        
        // Above: Jump / Sneak
        let jump = createButton(title: "Jump", frame: CGRect(x: rightX, y: bottomY - size - 10, width: size, height: size))
        jump.addTarget(self, action: #selector(keySpace(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        
        let sneak = createButton(title: "Sneak", frame: CGRect(x: rightX - size - 10, y: bottomY - size - 10, width: size, height: size))
        sneak.addTarget(self, action: #selector(keyShift(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        
        // Top: Inv / Pause / Chat
        let inv = createButton(title: "Inv", frame: CGRect(x: rightX, y: bottomY - size * 2 - 20, width: size, height: size))
        inv.addTarget(self, action: #selector(keyE(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        
        let chat = createButton(title: "Chat", frame: CGRect(x: rightX - size - 10, y: bottomY - size * 2 - 20, width: size, height: size))
        chat.addTarget(self, action: #selector(keyT(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        
        let pause = createButton(title: "Pause", frame: CGRect(x: rightX - size * 2 - 20, y: bottomY - size * 2 - 20, width: size, height: size))
        pause.addTarget(self, action: #selector(keyEsc(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
    }
    
    // --- Actions ---
    @objc func keyW(_ s: UIButton) { ios_inject_key(keycode: 0, pressed: s.isHighlighted) }
    @objc func keyA(_ s: UIButton) { ios_inject_key(keycode: 1, pressed: s.isHighlighted) }
    @objc func keyS(_ s: UIButton) { ios_inject_key(keycode: 2, pressed: s.isHighlighted) }
    @objc func keyD(_ s: UIButton) { ios_inject_key(keycode: 3, pressed: s.isHighlighted) }
    @objc func keySpace(_ s: UIButton) { ios_inject_key(keycode: 4, pressed: s.isHighlighted) }
    @objc func keyShift(_ s: UIButton) { ios_inject_key(keycode: 5, pressed: s.isHighlighted) }
    @objc func keyE(_ s: UIButton) { ios_inject_key(keycode: 6, pressed: s.isHighlighted) }
    @objc func keyT(_ s: UIButton) { ios_inject_key(keycode: 7, pressed: s.isHighlighted) }
    @objc func keyEsc(_ s: UIButton) { ios_inject_key(keycode: 8, pressed: s.isHighlighted) }
    
    @objc func mouseLeft(_ s: UIButton) { ios_inject_mouse_button(button: 0, pressed: s.isHighlighted) }
    @objc func mouseRight(_ s: UIButton) { ios_inject_mouse_button(button: 1, pressed: s.isHighlighted) }
    
    // --- Camera Look ---
    var lookTouch: UITouch?
    var lastPoint: CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: view)
            if loc.x > view.bounds.width / 3 && lookTouch == nil {
                lookTouch = touch
                lastPoint = loc
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = lookTouch, touches.contains(touch) {
            let loc = touch.location(in: view)
            if let last = lastPoint {
                let dx = Float(loc.x - last.x)
                let dy = Float(loc.y - last.y)
                ios_inject_mouse_motion(dx: dx, dy: dy)
            }
            lastPoint = loc
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = lookTouch, touches.contains(touch) {
            lookTouch = nil
            lastPoint = nil
        }
    }
}
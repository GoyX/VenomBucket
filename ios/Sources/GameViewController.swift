import UIKit

@_silgen_name("ios_inject_scroll")
func ios_inject_scroll(dy: Float)

@_silgen_name("ios_inject_key")
func ios_inject_key(keycode: UInt32, pressed: Bool)

@_silgen_name("ios_inject_mouse_motion")
func ios_inject_mouse_motion(dx: Float, dy: Float)

@_silgen_name("ios_inject_mouse_button")
func ios_inject_mouse_button(button: Int32, pressed: Bool)

@_silgen_name("ios_inject_cursor")
func ios_inject_cursor(x: Float, y: Float)

class GameViewController: UIViewController {
    private var didSetupUI = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isMultipleTouchEnabled = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.minimumNumberOfTouches = 2
        pan.cancelsTouchesInView = false
        view.addGestureRecognizer(pan)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didSetupUI && view.bounds.width > 0 {
            didSetupUI = true
            setupUI()
        }
    }
    
    func createButton(title: String, color: UIColor = UIColor(white: 0.2, alpha: 0.4)) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = color
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.isMultipleTouchEnabled = true
        return btn
    }
    
    func setupUI() {
        let size: CGFloat = 55
        let margin: CGFloat = 40
        let bottomY = view.bounds.height - size - margin
        
        // --- D-Pad (Bottom Left) ---
        let up = createButton(title: "▲")
        let down = createButton(title: "▼")
        let left = createButton(title: "◀")
        let right = createButton(title: "▶")
        
        up.frame = CGRect(x: margin + size, y: bottomY - size * 2 - 10, width: size, height: size)
        left.frame = CGRect(x: margin, y: bottomY - size - 5, width: size, height: size)
        right.frame = CGRect(x: margin + size * 2 + 10, y: bottomY - size - 5, width: size, height: size)
        down.frame = CGRect(x: margin + size, y: bottomY, width: size, height: size)
        
        view.addSubview(up); view.addSubview(down); view.addSubview(left); view.addSubview(right)
        
        up.addTarget(self, action: #selector(keyW(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        down.addTarget(self, action: #selector(keyS(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        left.addTarget(self, action: #selector(keyA(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        right.addTarget(self, action: #selector(keyD(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        
        // --- Action Buttons (Bottom Right) ---
        let rightX = view.bounds.width - size - margin
        let breakBtn = createButton(title: "Break", color: UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 0.6))
        let placeBtn = createButton(title: "Place", color: UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 0.6))
        let jump = createButton(title: "Jump")
        let inv = createButton(title: "Inv")
        let pause = createButton(title: "Pause")
        
        breakBtn.frame = CGRect(x: rightX - size * 2 - 10, y: bottomY, width: size, height: size)
        placeBtn.frame = CGRect(x: rightX, y: bottomY, width: size, height: size)
        jump.frame = CGRect(x: rightX, y: bottomY - size - 10, width: size, height: size)
        inv.frame = CGRect(x: rightX - size - 10, y: bottomY - size - 10, width: size, height: size)
        pause.frame = CGRect(x: rightX - size * 2 - 20, y: bottomY - size - 10, width: size, height: size)
        
        view.addSubview(breakBtn); view.addSubview(placeBtn); view.addSubview(jump); view.addSubview(inv); view.addSubview(pause)
        
        breakBtn.addTarget(self, action: #selector(mouseLeft(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        placeBtn.addTarget(self, action: #selector(mouseRight(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        jump.addTarget(self, action: #selector(keySpace(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        inv.addTarget(self, action: #selector(keyE(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        pause.addTarget(self, action: #selector(keyEsc(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        
        // --- F3 Debug Button (Top Right) ---
        let f3Btn = createButton(title: "F3", color: UIColor(white: 0.0, alpha: 0.5))
        f3Btn.frame = CGRect(x: view.bounds.width - 60, y: 40, width: 50, height: 40)
        f3Btn.addTarget(self, action: #selector(keyF3(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        view.addSubview(f3Btn)
    }
    
    // --- Actions ---
    @objc func keyW(_ s: UIButton) { ios_inject_key(keycode: 0, pressed: s.isHighlighted) }
    @objc func keyA(_ s: UIButton) { ios_inject_key(keycode: 1, pressed: s.isHighlighted) }
    @objc func keyS(_ s: UIButton) { ios_inject_key(keycode: 2, pressed: s.isHighlighted) }
    @objc func keyD(_ s: UIButton) { ios_inject_key(keycode: 3, pressed: s.isHighlighted) }
    @objc func keySpace(_ s: UIButton) { ios_inject_key(keycode: 4, pressed: s.isHighlighted) }
    @objc func keyE(_ s: UIButton) { ios_inject_key(keycode: 6, pressed: s.isHighlighted) }
    @objc func keyEsc(_ s: UIButton) { ios_inject_key(keycode: 8, pressed: s.isHighlighted) }
    @objc func keyF3(_ s: UIButton) { ios_inject_key(keycode: 9, pressed: s.isHighlighted) }
    
    @objc func mouseLeft(_ s: UIButton) {
        // Click center of screen to break blocks if not looking
        let center = view.center
        ios_inject_cursor(x: Float(center.x / view.bounds.width), y: Float(center.y / view.bounds.height))
        ios_inject_mouse_button(button: 0, pressed: s.isHighlighted) 
    }
    @objc func mouseRight(_ s: UIButton) {
        ios_inject_mouse_button(button: 1, pressed: s.isHighlighted) 
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        ios_inject_scroll(dy: Float(-translation.y))
        sender.setTranslation(.zero, in: view)
    }
    
    // --- Camera & Menu Clicks ---
    var lookTouch: UITouch?
    var lastPoint: CGPoint?
    var leftTouch: UITouch?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: view)
            if loc.x > view.bounds.width * 0.5 {
                if lookTouch == nil {
                    lookTouch = touch
                    lastPoint = loc
                }
            } else {
                if leftTouch == nil {
                    leftTouch = touch
                    let nx = Float(loc.x / view.bounds.width)
                    let ny = Float(loc.y / view.bounds.height)
                    ios_inject_cursor(x: nx, y: ny)
                    ios_inject_mouse_button(button: 0, pressed: true)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = lookTouch, touches.contains(touch) {
            let loc = touch.location(in: view)
            if let last = lastPoint {
                ios_inject_mouse_motion(dx: Float(loc.x - last.x), dy: Float(loc.y - last.y))
            }
            lastPoint = loc
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == lookTouch {
                lookTouch = nil
                lastPoint = nil
            }
            if touch == leftTouch {
                leftTouch = nil
                ios_inject_mouse_button(button: 0, pressed: false)
            }
        }
    }
}
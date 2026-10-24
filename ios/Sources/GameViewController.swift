import UIKit

@_silgen_name("ios_inject_key")
func ios_inject_key(keycode: UInt32, pressed: Bool)

@_silgen_name("ios_inject_mouse_motion")
func ios_inject_mouse_motion(dx: Float, dy: Float)

@_silgen_name("ios_inject_mouse_button")
func ios_inject_mouse_button(button: Int32, pressed: Bool)

@_silgen_name("ios_inject_cursor")
func ios_inject_cursor(x: Float, y: Float)

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isMultipleTouchEnabled = true
        
        setupResponsiveUI()
    }
    
    func createButton(title: String, color: UIColor = UIColor(white: 0.2, alpha: 0.4)) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = color
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.isMultipleTouchEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
    
    func setupResponsiveUI() {
        let safeArea = view.safeAreaLayoutGuide
        
        // --- Movement Pad (Bottom Left) ---
        let moveSize: CGFloat = 55
        let up = createButton(title: "▲")
        let down = createButton(title: "▼")
        let left = createButton(title: "◀")
        let right = createButton(title: "▶")
        
        view.addSubview(up); view.addSubview(down); view.addSubview(left); view.addSubview(right)
        
        NSLayoutConstraint.activate([
            left.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            left.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -50),
            left.widthAnchor.constraint(equalToConstant: moveSize),
            left.heightAnchor.constraint(equalToConstant: moveSize),
            
            right.leadingAnchor.constraint(equalTo: left.trailingAnchor, constant: 10),
            right.centerYAnchor.constraint(equalTo: left.centerYAnchor),
            right.widthAnchor.constraint(equalToConstant: moveSize),
            right.heightAnchor.constraint(equalToConstant: moveSize),
            
            up.centerXAnchor.constraint(equalTo: left.centerXAnchor),
            up.bottomAnchor.constraint(equalTo: left.topAnchor, constant: -10),
            up.widthAnchor.constraint(equalToConstant: moveSize),
            up.heightAnchor.constraint(equalToConstant: moveSize),
            
            down.centerXAnchor.constraint(equalTo: left.centerXAnchor),
            down.topAnchor.constraint(equalTo: left.bottomAnchor, constant: 10),
            down.widthAnchor.constraint(equalToConstant: moveSize),
            down.heightAnchor.constraint(equalToConstant: moveSize)
        ])
        
        up.addTarget(self, action: #selector(keyW(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        down.addTarget(self, action: #selector(keyS(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        left.addTarget(self, action: #selector(keyA(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        right.addTarget(self, action: #selector(keyD(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        
        // --- Action Buttons (Bottom Right) ---
        let actSize: CGFloat = 55
        
        let jump = createButton(title: "Jump")
        let breakBtn = createButton(title: "Break", color: UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 0.6))
        let placeBtn = createButton(title: "Place", color: UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 0.6))
        
        let inv = createButton(title: "Inv")
        let pause = createButton(title: "Pause")
        let chat = createButton(title: "Chat")
        
        view.addSubview(jump); view.addSubview(breakBtn); view.addSubview(placeBtn)
        view.addSubview(inv); view.addSubview(pause); view.addSubview(chat)
        
        NSLayoutConstraint.activate([
            // Row 1 (Bottom)
            breakBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -150),
            breakBtn.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            breakBtn.widthAnchor.constraint(equalToConstant: actSize),
            breakBtn.heightAnchor.constraint(equalToConstant: actSize),
            
            jump.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            jump.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            jump.widthAnchor.constraint(equalToConstant: actSize),
            jump.heightAnchor.constraint(equalToConstant: actSize),
            
            placeBtn.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            placeBtn.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            placeBtn.widthAnchor.constraint(equalToConstant: actSize),
            placeBtn.heightAnchor.constraint(equalToConstant: actSize),
            
            // Row 2
            pause.trailingAnchor.constraint(equalTo: breakBtn.trailingAnchor),
            pause.bottomAnchor.constraint(equalTo: breakBtn.topAnchor, constant: -10),
            pause.widthAnchor.constraint(equalToConstant: actSize),
            pause.heightAnchor.constraint(equalToConstant: actSize),
            
            inv.trailingAnchor.constraint(equalTo: jump.trailingAnchor),
            inv.bottomAnchor.constraint(equalTo: jump.topAnchor, constant: -10),
            inv.widthAnchor.constraint(equalToConstant: actSize),
            inv.heightAnchor.constraint(equalToConstant: actSize),
            
            chat.trailingAnchor.constraint(equalTo: placeBtn.trailingAnchor),
            chat.bottomAnchor.constraint(equalTo: placeBtn.topAnchor, constant: -10),
            chat.widthAnchor.constraint(equalToConstant: actSize),
            chat.heightAnchor.constraint(equalToConstant: actSize)
        ])
        
        jump.addTarget(self, action: #selector(keySpace(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        breakBtn.addTarget(self, action: #selector(mouseLeft(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        placeBtn.addTarget(self, action: #selector(mouseRight(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        inv.addTarget(self, action: #selector(keyE(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        pause.addTarget(self, action: #selector(keyEsc(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
        chat.addTarget(self, action: #selector(keyT(_:)), for: [.touchDown, .touchUpInside, .touchUpOutside])
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
    
    @objc func mouseLeft(_ s: UIButton) {
        // We need to inject cursor to center of screen so we click the menu button
        let center = view.center
        ios_inject_cursor(x: Float(center.x / view.bounds.width), y: Float(center.y / view.bounds.height))
        ios_inject_mouse_button(button: 0, pressed: s.isHighlighted) 
    }
    @objc func mouseRight(_ s: UIButton) {
        ios_inject_mouse_button(button: 1, pressed: s.isHighlighted) 
    }
    
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
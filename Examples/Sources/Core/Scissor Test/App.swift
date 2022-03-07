import Raylib

@main struct Scisor: Applet {
	var area = Rectangle(at: 0, 0, size: 200, 200)
	var isScissorEnabled = true
	
	init() {
		// FIXME: This seems to be bugged on retina displays
		Window.create(800, by: 450, title: "Example - Core - Scissor Test")
		Application.target(fps: 60)
	}
	
	mutating func update() {
		if Keyboard.s.isPressed {
			isScissorEnabled.toggle()
		}
		
		area.position = Mouse.position - area.size / 2
	}
	
	func draw(using renderer: Renderer2D) {
		renderer.wire.rectangle(area, color: .black)
		renderer.text("Press S to toggle scissor test", at: 10, 10)
		
		guard isScissorEnabled else { return }
		renderer.scissor(at: area.position, size: area.size) {
			renderer.rectangle(at: .zero, size: Window.size, color: .red)
			renderer.text("Move the mouse around to reveal this text!", at: 190, 200, color: .lightGray)
		}
	}
	
}

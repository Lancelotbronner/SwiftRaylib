import Raylib

//MARK: - Application

@main struct BlendModes: Applet {
	let background: Texture
	let foreground: Texture
	var currentModeIndex = 0
	
	let blendModes: [(Blend, String)] = [
		(Blend.alpha, "ALPHA"),
		(Blend.additive, "ADDITIVE"),
		(Blend.multiplied, "MULTIPLIED"),
		(Blend.add, "ADD COLORS"),
		(Blend.subtract, "SUBTRACT"),
	]
	
	init() {
		Window.create(800, by: 450, title: "Example - Textures - Blend Modes")
		Application.target(fps: 60)
		
		background = Filesystem
			.file(at: "background.png", from: .module)
			.loadAsTexture()
		
		foreground = Filesystem
			.file(at: "foreground.png", from: .module)
			.loadAsTexture()
	}
	
	mutating func update() {
		if Keyboard.space.isPressed {
			currentModeIndex = blendModes.roundRobin(after: currentModeIndex)
		}
	}
	
	func draw(using renderer: Renderer2D) {
		renderer.texture(background, at: Window.size / 2 - background.size / 2)
		
		// Apply the blend mode and then draw the foreground texture
		let (blend, name) = blendModes[currentModeIndex]
		blend.render {
			renderer.texture(foreground, at: Window.size / 2 - foreground.size / 2)
		}
		
		// Draw the texts
		Renderer.pointSize = 10
		Renderer.textColor = .gray
		renderer.text(center: "Press SPACE to change blend modes.", offset: 0, 140)
		renderer.text(center: "Current: \(name)", offset: 0, 160)
		
		renderer.text("(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)", at: Window.width - 330, Window.height - 20)
	}
}

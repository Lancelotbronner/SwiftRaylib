import Raylib

//MARK: - Menu Scene

struct MenuScene: Scene {
	
	//MARK: Properties
	
	var demo: Level?
	
	//MARK: Lifecycle
	
	mutating func load() {
		demo = try! Filesystem
			.file(at: "Levels/Demo.json", from: .module)
			.loadAsJSON()
	}
	
	//MARK: Simulation Methods
	
	func update() -> SceneAction {
		.continue
	}
	
	//MARK: Rendering Methods
	
	func draw(using renderer: Renderer2D) {
		// Draw the map
		demo?.draw(using: renderer)
		
		// Dim the background
		// TODO: Dim background method
		
		// Draw the title
		renderer.text(center: "Raylib RPG Example", offset: 0, -40, size: 40, color: .blue)
		
		// Version and Copyright
		renderer.text("C © 2022 Jeffery Myers", at: 10, Window.height - 20, size: 10, color: .gray)
		renderer.text("Swift © 2022 Christophe Bronner", at: 10, Window.height - 40, size: 10, color: .gray)
		renderer.text("v4.0-dev", at: 10, Window.height - 70, size: 20)
		
		// Play Button
//		if (CenteredButton(GetScreenHeight() / 4, "Play"))
//			StartGame();
		
		// Options Button
//		CenteredButton(GetScreenHeight()/2, "Options");
		
		// Quit Button
//		if (CenteredButton(GetScreenHeight() - (GetScreenHeight() / 4), "Quit"))
//			QuitApplication();
	}
	
}

import Raylib

struct LoadingScene: Scene {
	
	//MARK: Properties
	
	private var timeline = Timeline()
	
	private var step = 0
	private var total = 0
	
	private var texturesToLoad = [
		("tilemap.png", "tilemap"),
		("Icons/attack.png", "attack"),
	]
	
	private var soundsToLoad = [
		"Sounds/click-1.ogg",
		"Sounds/coins-handling-1.ogg",
		"Sounds/door-open-1.ogg",
		"Sounds/pot-metal-1.ogg",
		"Sounds/creature-1.ogg",
		"Sounds/creature-2.ogg",
		"Sounds/woosh-1.ogg",
		"Sounds/knife-slice-1.ogg",
		"Sounds/chop-1.ogg",
		"Sounds/power-up-2.ogg",
	]
	
	//MARK: Computed Properties
	
	private var progress: Double {
		step.toDouble / total.toDouble
	}
	
	//MARK: Initialization
	
	init() {
		total = texturesToLoad.count + soundsToLoad.count
	}
	
	//MARK: Events
	
	func wake() {
		Renderer.pointSize = 20
		Renderer.textColor = .white
	}
	
	//MARK: Updating
	
	mutating func update() -> SceneAction {
		timeline.update()
		
		switch true {
		case !texturesToLoad.isEmpty:
			let (path, name) = texturesToLoad.removeLast()
			let texture = Filesystem
				.file(at: path, from: .module)
				.loadAsTexture()
			Resources.textures.register(texture, for: name)
			
		case !soundsToLoad.isEmpty:
			let sound = soundsToLoad.removeLast()
//			Filesystem.file(at: "Resources/\(sound)").loadAsSound()
			
		default:
			return .replace(with: MenuScene())
		}
		
		return .continue
	}
	
	//MARK: Drawing
	
	func draw(using renderer: Renderer2D) {
		// Loading messages
		
		renderer.text(center: "Loading...", offset: 0, -40)
		
		// Animation to let users know the app hasn't frozen
		
		renderer.rectangle(at: Window.size - Vector2(20), size: Vector2f(timeline.time.toFloat.sin() * 10), color: .blue)
		
		// Progress bar
		
		let progressWidth = (Window.width * 3 / 5).toDouble * progress
		renderer.rectangle(at: Window.width / 5, Window.height / 2, size: progressWidth.toInt, 5, color: .raywhite)
		renderer.wire.rectangle(at: Window.width / 5, Window.height / 2, size: progressWidth.toInt, 5, thickness: 2, color: .white)
	}
	
}

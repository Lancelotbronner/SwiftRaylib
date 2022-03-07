// TODO: Find a way to plug an async load() method
// TODO: Find a way to make scenes use an async load() method
// TODO: Turn filesystem loads into async methods

//MARK: - App

public protocol App {
	
	init()
	
	var initial: Scene { get }
	
	mutating func load()
	mutating func unload()
	
}

extension App {
	
	//MARK: Defaults
	
	@inlinable public mutating func load() { }
	@inlinable public mutating func unload() { }
	
	//MARK: Methods
	
	@inlinable public static func main() {
		var app = Self.init()
		
		if !Window.isReady {
			Window.create(title: String(describing: Self.self))
		}
		
		var navigation = [app.initial]
		var scene: Scene {
			get { navigation[navigation.count - 1] }
			set { navigation[navigation.count - 1] = newValue }
		}
		
		app.load()
		
		var action = SceneAction.push(scene)
		while Application.isRunning {
			guard !navigation.isEmpty else { break }
			
			switch action {
			case .push, .replace: scene.load()
			case .dismiss: scene.wake()
			case .continue: break
			}
			
			action = scene.update()
			scene.render()
			
			Renderer.render { renderer in
				renderer.clear(to: Renderer.background)
				scene.draw(using: renderer)
			}
			
			switch action {
			case let .push(next):
				scene.sleep()
				navigation.append(next)
				
			case let .replace(with: next):
				scene.unload()
				navigation.append(next)
				
			case .dismiss:
				scene.unload()
				navigation.removeLast()
				
			case .continue:
				break
			}
		}
		
		app.unload()
		Application.quit()
	}
	
}

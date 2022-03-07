import Raylib

//MARK: - Level

struct Level: Decodable {
	
	//MARK: Properties
	
	let height: Int
	let width: Int
	
	let tilewidth: Int
	let tileheight: Int
	
	let orientation: Orientation
	
	let layers: [Layer]
	let tilesets: [Tileset]
	
	//MARK: Methods
	
	func draw(using renderer: Renderer2D, for viewport: Rectangle) {
		for layer in layers {
			layer.draw(using: renderer, in: viewport, within: self)
		}
	}
	
	//MARK: Utility Methods
	
	func displayRect(of position: Vector2i) -> Rectangle {
		orientation.display(at: position, using: tilewidth, tileheight)
	}
	
}

//MARK: - Error

enum LevelError: Error {
	case invalidLayerType(String)
}

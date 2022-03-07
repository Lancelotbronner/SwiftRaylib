//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2021-12-27.
//

//MARK: - Applet

public protocol Applet {
	
	init()
	
	mutating func load()
	mutating func update()
	func render()
	func draw(using renderer: Renderer2D)
	mutating func unload()
	
}

extension Applet {
	
	//MARK: Defaults
	
	@inlinable public func load() { }
	@inlinable public func update() { }
	@inlinable public func render() { }
	@inlinable public func unload() { }
	
	//MARK: @main
	
	@inlinable public static func main() {
		var app = Self.init()
		
		if !Window.isReady {
			Window.create(title: String(describing: Self.self))
		}
		
		app.load()
		
		Application.run {
			app.update()
			app.render()
			Renderer.render { renderer in
				renderer.clear(to: Renderer.background)
				app.draw(using: renderer)
			}
		}
		
		app.unload()
		Application.quit()
	}
	
}

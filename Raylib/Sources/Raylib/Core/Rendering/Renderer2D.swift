//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2022-01-12.
//

import CRaylib

//MARK: - Renderer

public struct Renderer2D {
	
	//MARK: Computed Properties
	
	@inlinable public var wire: WireRenderer2D {
		WireRenderer2D()
	}
	
	//MARK: Initialization
	
	@usableFromInline init() { }
	
	//MARK: Methods
	
	/// Set background color (framebuffer clear color)
	@inlinable public func clear(to color: Color) {
		ClearBackground(color.toRaylib)
	}
	
	//MARK: Scissor Methods
	
	/// Begin scissor mode (define screen area for following drawing); End scissor mode
	@inlinable public func scissor(at x: Int, _ y: Int, size width: Int, by height: Int, draw: () -> Void) {
		BeginScissorMode(x.toInt32, y.toInt32 - height.toInt32, width.toInt32, height.toInt32)
		draw()
		EndScissorMode()
	}
	
	/// Begin scissor mode (define screen area for following drawing); End scissor mode
	@inlinable public func scissor(at position: Vector2f, size: Vector2f, draw: () -> Void) {
		scissor(at: position.x.toInt, position.y.toInt, size: size.x.toInt, by: size.y.toInt, draw: draw)
	}
	
	/// Begin scissor mode (define screen area for following drawing); End scissor mode
	@inlinable public func scissor(in area: Rectangle, draw: () -> Void) {
		scissor(at: area.position, size: area.size, draw: draw)
	}
	
}

//MARK: - Wire Renderer

public struct WireRenderer2D {
	
	//MARK: Initialization
	
	@usableFromInline init() { }
	
}

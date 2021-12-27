//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2021-12-26.
//

//MARK: - Scene

public protocol Scene {
	
	/// Called when the scene is first loaded
	mutating func load()
	
	/// Called every frame to simulate the scene
	mutating func update() -> SceneAction
	
	/// Called every frame to draw the scene
	func draw()
	
	/// Called when the scene is about to exit to cleanup
	mutating func unload()
	
}

extension Scene {
	
	//MARK: Defaults
	
	public mutating func load() { }
	public mutating func unload() { }
	
}

//MARK: - Scene Action

public enum SceneAction {
	
	/// The scene keeps simulating
	case `continue`
	
	/// A new scene is pushed onto navigation
	case push(Scene)
	
	/// This scene is dismissed, returning to the last scene or exiting if it was the last one
	case dismiss
	
}
//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2021-12-28.
//

import Raylib

//MARK: - Game Over Scene

struct GameOverScene: Scene {
	
	//MARK: Properties
	
	let score: Int
	
	//MARK: Simulation Methods
	
	public func update() -> SceneAction {
		if Keyboard.enter.isPressed {
			return .replace(with: GameplayScene(for: .level1))
		}
		
		return .continue
	}
	
	//MARK: Drawing Methods
	
	func draw(using renderer: Renderer2D) {
		renderer.text("SCORE: \(score)", at: Window.width / 2, 50, size: 40, alignment: .center, color: .black)
		renderer.text(center: "PRESS [ENTER] TO PLAY AGAIN", offset: 0, -50, size: 40, color: .gray)
	}
	
}

//
//  File.swift
//  File
//
//  Created by Christophe Bronner on 2021-09-01.
//

import Raylib

@main struct InputKeyboard: Applet {
	var ballPosition: Vector2f
	
	init() {
		Window.create(800, by: 450, title: "Example - Core - Input Keys")
		Application.target(fps: 60)
		
		ballPosition = Window.size / 2
	}
	
	mutating func update() {
		if Keyboard.right.isDown {
			ballPosition.x += 2
		}
		if Keyboard.left.isDown {
			ballPosition.x -= 2
		}
		if Keyboard.up.isDown {
			ballPosition.y -= 2
		}
		if Keyboard.down.isDown {
			ballPosition.y += 2
		}
	}
	
	func draw(using renderer: Renderer2D) {
		renderer.text("Move the ball with the arrow keys", at: 10, 10, color: .darkGray)
		renderer.circle(at: ballPosition, radius: 50, color: .maroon)
	}
}

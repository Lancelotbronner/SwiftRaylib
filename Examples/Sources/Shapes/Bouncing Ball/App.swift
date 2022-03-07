//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2021-12-26.
//

import Raylib

@main struct BouncingBall: Applet {
	let BALL_RADIUS = 20
	
	var position: Vector2f
	var speed: Vector2f
	var paused = false
	var framesCounter = 0
	
	init() {
		Window.create(800, by: 450, title: "Example - Shapes - Bouncing Ball")
		Application.target(fps: 60)
		
		position = Window.size / 2
		speed = Vector2f(5, 4)
	}
	
	mutating func update() {
		if Keyboard.space.isPressed {
			paused.toggle()
		}
		
		guard !paused else {
			framesCounter += 1
			return
		}
		
		position += speed
		
		if position.x.toInt >= Window.width - BALL_RADIUS || position.x.toInt <= BALL_RADIUS {
			speed.x.negate()
		}
		
		if position.y.toInt >= Window.height - BALL_RADIUS || position.y.toInt <= BALL_RADIUS {
			speed.y.negate()
		}
	}
	
	func draw(using renderer: Renderer2D) {
		renderer.circle(at: position, radius: BALL_RADIUS.toFloat, color: .maroon)
		renderer.text("PRESS SPACE TO PAUSE", at: 10, Window.height - 25, size: 20, color: .lightGray)
		
		if paused, framesCounter / 30 % 2 == 0 {
			renderer.text("PAUSED", at: 350, 200, size: 40, color: .gray)
		}
		
		renderer.fps(at: 10, 10)
	}
	
}

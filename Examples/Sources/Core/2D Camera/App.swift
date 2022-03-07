//
//  File.swift
//  File
//
//  Created by Christophe Bronner on 2021-09-04.
//

import Raylib

//MARK: - Application

@main struct ExampleCamera2D: Applet {
	let NUMBER_OF_BUILDINGS = 100

	var player: Rectangle
	var camera: Camera2D
	var buildings: [Building]

	init() {
		Window.create(800, by: 450, title: "Example - Core - 2D Camera")
		Renderer.background = .darkGray
		Application.target(fps: 60)

		player = Rectangle(at: Vector2f(400, 280), size: Vector2f(40, 40))
		camera = Camera2D(at: player.position + 20)

		var offset: Float = 0
		buildings = (0 ..< NUMBER_OF_BUILDINGS).map { _ in
			let building = Building.random(offset: offset)
			offset += building.rect.width
			return building
		}
	}

	mutating func update() {
		if Keyboard.right.isDown {
			player.x += 2
		} else if Keyboard.left.isDown {
			player.x -= 2
		}

		camera.target = player.position + 20

		if Keyboard.a.isDown {
			camera.rotation -= 1
		} else if Keyboard.s.isDown {
			camera.rotation += 1
		}

		camera.rotation.clamp(between: -40, and: 40)

		camera.zoom += Mouse.wheel * 0.05
		camera.zoom.clamp(between: 0.1, and: 3)

		if Keyboard.r.isPressed {
			camera.zoom = 1
			camera.rotation = 0
		}
	}

	func draw(using renderer: Renderer2D) {
		camera.render { view in
			for building in buildings {
				view.rectangle(building.rect, color: building.color)
			}

			view.rectangle(player, color: .red)

			view.line(
				from: camera.target.x.toInt, -Window.height * 10,
				to: camera.target.x.toInt, Window.height * 10,
				color: .green)

			view.line(
				from: -Window.width.toInt * 10, camera.target.y.toInt,
				to: Window.width.toInt * 10, camera.target.y.toInt,
				color: .green)
		}

		renderer.text("SCREEN AREA", at: 640, 10, color: .red)
		
		Renderer.color = .red
		renderer.rectangle(at: 0, 0, size: Window.width, 5)
		renderer.rectangle(at: 0, 5, size: 5, Window.height - 10)
		renderer.rectangle(at: Window.width - 5, 5, size: 5, Window.height - 10)
		renderer.rectangle(at: 0, Window.height - 5, size: Window.width, 5)
		
		renderer.rectangle(at: 10, 10, size: 250, 113, color: .skyBlue.faded(to: 0.5))
		renderer.wire.rectangle(at: 10, 10, size: 250, 113, color: .blue)
		
		Renderer.textColor = .darkGray
		Renderer.pointSize = 10
		renderer.text("Free 2D camera controls:", at: 20, 20, color: .black)
		renderer.text("- Right/Left to move Offset", at: 40, 40);
		renderer.text("- Mouse Wheel to Zoom in-out", at: 40, 60);
		renderer.text("- A / S to Rotate", at: 40, 80);
		renderer.text("- R to reset Zoom and Rotation", at: 40, 100);
	}
}

//MARK: - Game

struct Building {
	var rect: Rectangle
	var color: Color

	static func random(offset: Float) -> Building {
		let size = Vector2f(.random(in: 50 ... 200), .random(in: 100 ... 800))
		let position = Vector2f(-6000 + offset, Window.height.toFloat - 130 - size.y)
		let color = Color.rgb(.random(in: 200 ... 240), .random(in: 200 ... 240), .random(in: 200 ... 250))
		return Building(rect: Rectangle(at: position, size: size), color: color)
	}
}

//
//  File.swift
//  File
//
//  Created by Christophe Bronner on 2021-09-10.
//

import Raylib

@main struct ImageGeneration: Applet {
	var textures: [Texture]
	var index = 0
	
	init() {
		Window.create(800, by: 450, title: "Examples - Textures - Image Generation")
		Application.target(fps: 60)
		
		textures = [
			Image.gradientV(size: Window.width, by: Window.height, from: .red, to: .blue),
			Image.gradientH(size: Window.width, by: Window.height, from: .red, to: .blue),
			Image.gradientRadial(size: Window.width, by: Window.height, from: .white, to: .black),
			Image.checked(size: Window.width, by: Window.height, tiles: 32, 32, colors: .maroon, .darkBlue),
			Image.whiteNoise(size: Window.width, by: Window.height, factor: 0.5),
			// Was removed due to license issues
//			Image.perlinNoise(size: Window.width, Window.height, offset: 50, 50, scale: 4),
			Image.cellular(size: Window.width, by: Window.height, cell: 32),
		].map { $0.convertToTexture() }
	}
	
	mutating func update() {
		if Mouse.left.isPressed || Keyboard.right.isPressed {
			index = textures.roundRobin(after: index)
		}
		if Mouse.right.isPressed || Keyboard.left.isPressed {
			index = textures.roundRobin(before: index)
		}
	}
	
	func draw(using renderer: Renderer2D) {
		renderer.texture(textures[index], at: .zero)
		
		renderer.rectangle(at: 30, 400, size: 325, 30, color: .skyBlue.faded(to: 0.5))
		renderer.wire.rectangle(at: 30, 400, size: 325, 30, color: .white.faded(to: 0.5))
		renderer.text("MOUSE LEFT BUTTON to CYCLE PROCEDURAL TEXTURES", at: 40, 410, size: 10, color: .white)
		
		switch index {
		case 0: renderer.text("VERTICAL GRADIENT", at: 560, 10, color: .raywhite)
		case 1: renderer.text("HORIZONTAL GRADIENT", at: 540, 10, color: .raywhite)
		case 2: renderer.text("RADIAL GRADIENT", at: 580, 10, color: .lightGray)
		case 3: renderer.text("CHECKED", at: 680, 10, color: .raywhite)
		case 4: renderer.text("WHITE NOISE", at: 640, 10, color: .red)
			// was removed due to license issues
//		case 5: renderer.text("PERLIN NOISE", at: 630, 10, color: .raywhite)
		case 5: renderer.text("CELLULAR", at: 670, 10, color: .raywhite)
		default: break
		}
	}
	
}

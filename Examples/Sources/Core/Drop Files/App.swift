//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2021-12-26.
//

import Raylib

@main struct DropFiles: Applet {
	
	init() {
		Window.create(800, by: 450, title: "Example - Core - Drop Files")
		Application.target(fps: 60)
	}
	
	func draw(using renderer: Renderer2D) {
		let files = DragAndDrop.paths
		
		if files.isEmpty {
			renderer.text("Drop your files to this window!", at: 100, 40, size: 20, color: .darkGray)
			
		} else {
			renderer.text("Drop your files to this window!", at: 100, 40, size: 20, color: .darkGray)
			
			for i in files.indices {
				renderer.rectangle(at: 0, 85 + 40 * i, size: Window.width, 40, color: .lightGray.faded(to: i % 2 == 0 ? 0.5 : 0.3))
				renderer.text(files[i], at: 120, 100 + 40 * i, size: 10, color: .gray)
			}
			
			renderer.text("Drop new files...", at: 100, 110 + 40 * files.count, size: 20, color: .darkGray)
		}
	}
	
	func unload() {
		DragAndDrop.clear()
	}
	
}

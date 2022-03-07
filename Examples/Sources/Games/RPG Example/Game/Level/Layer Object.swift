//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2022-01-27.
//

import Raylib

//MARK: - Object Layer

struct ObjectLayer: Decodable, Identifiable {
	
	//MARK: Constants
	
	static let type = "objectgroup"
	
	//MARK: Properties
	
	let id: Int
	
	let width: Int
	let height: Int
	
	let data: [Int]
	
	//MARK: Rendering Methods
	
	func draw(using renderer: Renderer2D, for viewport: Rectangle, within level: Level) {
		
	}
	
}

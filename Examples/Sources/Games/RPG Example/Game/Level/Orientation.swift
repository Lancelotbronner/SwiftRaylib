//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2022-01-27.
//

import Raylib

//MARK: - Orientation

enum Orientation: String, Decodable {
	
	//MARK: Cases
	
	case orthogonal
	case isometric
	
	//MARK: Computed Properties
	
	func display(at position: Vector2f, using size: Vector2f) -> Rectangle {
		switch self {
		case .orthogonal:
			return Rectangle(at: position * size, size: size)
			
		case .isometric:
			let x = position.x * size.x / 2 - position.y * size.y / 2
			let y = position.y * size.y / 2 + position.x * size.y / 2
			return Rectangle(at: x, y, size: size.x, size.y)
		}
	}
	
}

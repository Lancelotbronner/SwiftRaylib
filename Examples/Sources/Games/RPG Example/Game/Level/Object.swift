//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2022-01-27.
//

import Raylib

//MARK: - Object

struct Object: Decodable, Identifiable {
	
	//MARK: Properties
	
	let id: Int
	
	let name: String
	
	let frame: Rectangle
	let rotation: Int
	
	let content: ObjectContent
	
	//MARK: Codable
	
	private enum CodingKeys: String, CodingKey {
		case id
		case name
		case x
		case y
		case width
		case height
		case rotation
	}
	
	init(from decoder: Decoder) throws {
		let c = try decoder.container(keyedBy: CodingKeys.self)
		
		let x = try c.decode(Float.self, forKey: .x)
		let y = try c.decode(Float.self, forKey: .y)
		let width = try c.decode(Float.self, forKey: .width)
		let height = try c.decode(Float.self, forKey: .height)
		
		id = try c.decode(Int.self, forKey: .id)
		name = try c.decode(String.self, forKey: .name)
		rotation = try c.decode(Int.self, forKey: .rotation)
		
		
	}
	
}

//MARK: - Object Content

enum ObjectContent {
	case text(TextObject)
}

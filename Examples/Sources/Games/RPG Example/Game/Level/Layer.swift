//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2022-01-27.
//

import Raylib

//MARK: - Layer

enum Layer: Identifiable, Decodable {
	
	//MARK: Cases
	
	case tile(TileLayer)
	case object(ObjectLayer)
	
	//MARK: Computed Properties
	
	var id: Int {
		switch self {
		case let .tile(layer): return layer.id
		case let .object(layer): return layer.id
		}
	}
	
	//MARK: Methods
	
	func draw(using renderer: Renderer2D, in viewport: Rectangle, within level: Level) {
		switch self {
		case let .tile(layer): layer.draw(using: renderer, for: viewport, within: level)
		case let .object(layer): layer.draw(using: renderer, for: viewport, within: level)
		}
	}
	
	//MARK: Codable
	
	private enum CodingKeys: String, CodingKey {
		case type
	}
	
	init(from decoder: Decoder) throws {
		let c = try decoder.container(keyedBy: CodingKeys.self)
		let type = try c.decode(String.self, forKey: .type)
		
		switch type {
		case TileLayer.type: self = .tile(try .init(from: decoder))
		case ObjectLayer.type: self = .object(try .init(from: decoder))
		default: throw LevelError.invalidLayerType(type)
		}
	}
	
}

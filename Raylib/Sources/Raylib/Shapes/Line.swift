//
//  File.swift
//  File
//
//  Created by Christophe Bronner on 2021-09-09.
//

import CRaylib

//MARK: - Line

public struct Line {
	
	//MARK: Properties
	
	public var start: Vector2f
	public var end: Vector2f
	
	//MARK: Initialization
	
	public init(from start: Vector2f, to end: Vector2f) {
		self.start = start
		self.end = end
	}
	
	//MARK: Collision Methods
	
	@inlinable
	public func collision(with other: Line) -> Vector2f? {
		var tmp = Vector2f.zero
		return CheckCollisionLines(start, end, other.start, other.end, &tmp) ? tmp : nil
	}
	
}
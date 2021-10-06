//
//  File.swift
//  File
//
//  Created by Christophe Bronner on 2021-09-06.
//

//MARK: - Ring

public struct Ring {
	
	//MARK: Properties
	
	public var position: Vector2f
	public var innerRadius: Float
	public var outerRadius: Float
	public var segments: Int?
	public var start: Angle
	public var end: Angle
	
	//MARK: Initialization
	
	@inlinable
	public init(at position: Vector2f, inner innerRadius: Float, outer outerRadius: Float, segments: Int? = nil, from start: Angle, to end: Angle) {
		self.position = position
		self.innerRadius = innerRadius
		self.outerRadius = outerRadius
		self.segments = segments
		self.start = start
		self.end = end
	}
	
	@inlinable
	public init(at position: Vector2f, radius: Float, width: Float, segments: Int? = nil, from start: Angle, to end: Angle) {
		self.position = position
		self.innerRadius = radius - width
		self.outerRadius = radius
		self.segments = segments
		self.start = start
		self.end = end
	}
	
}

//
//  File.swift
//  File
//
//  Created by Christophe Bronner on 2021-09-04.
//

import CRaylib

//MARK: - Wire 2D Renderer

extension WireRenderer2D {
	
	//MARK: Triangle
	
	@inlinable public func triangle(_ p1: Vector2f, _ p2: Vector2f, _ p3: Vector2f, color: Color = Renderer.color) {
		DrawTriangleLines(p1.toRaylib, p2.toRaylib, p3.toRaylib, color.toRaylib)
	}
	
	//MARK: Rectangle
	
	@inlinable public func rectangle(at x: Int, _ y: Int, size width: Int, _ height: Int, color: Color = Renderer.color) {
		DrawRectangleLines(x.toInt32, y.toInt32, width.toInt32, height.toInt32, color.toRaylib)
	}
	
	@inlinable public func rectangle(_ rect: Rectangle, color: Color = Renderer.color) {
		DrawRectangleLines(rect.x.toInt32, rect.y.toInt32, rect.width.toInt32, rect.height.toInt32, color.toRaylib)
	}
	
	@inlinable public func rectangle(at x: Int, _ y: Int, size width: Int, _ height: Int, thickness: Int, color: Color = Renderer.color) {
		DrawRectangleLinesEx(.init(x: x.toFloat, y: y.toFloat, width: width.toFloat, height: height.toFloat), thickness.toFloat, color.toRaylib)
	}
	
	@inlinable public func rectangle(_ rect: Rectangle, thickness: Float, color: Color = Renderer.color) {
		DrawRectangleLinesEx(rect.toRaylib, thickness, color.toRaylib)
	}
	
	//MARK: Rounded Rectangle
	
	@inlinable public func roundedRectangle(_ shape: RoundedRectangle, thickness: Float, color: Color = Renderer.color) {
		DrawRectangleRoundedLines(shape.frame.toRaylib, shape.cornerRadius, shape.segments.toInt32, thickness, color.toRaylib)
	}
	
	//MARK: Circle
	
	@inlinable public func circle(at x: Int, _ y: Int, radius: Float, color: Color = Renderer.color) {
		DrawCircleLines(x.toInt32, y.toInt32, radius, color.toRaylib)
	}
	
	@inlinable public func circle(at position: Vector2f, radius: Float, color: Color = Renderer.color) {
		DrawCircleLines(position.x.toInt32, position.y.toInt32, radius, color.toRaylib)
	}
	
	//MARK: Sector
	
	@inlinable public func sector(at x: Int, _ y: Int, radius: Float, from start: Angle<Float>, to end: Angle<Float>, segments: Int = 0, color: Color = Renderer.color) {
		DrawCircleSectorLines(Vector2f(x.toFloat, y.toFloat).toRaylib, radius, start.toDegrees, end.toDegrees, segments.toInt32, color.toRaylib)
	}
	
	@inlinable public func sector(at position: Vector2f, radius: Float, from start: Angle<Float>, to end: Angle<Float>, segments: Int = 0, color: Color = Renderer.color) {
		DrawCircleSectorLines(position.toRaylib, radius, start.toDegrees, end.toDegrees, segments.toInt32, color.toRaylib)
	}
	
	//MARK: Ellipse
	
	@inlinable public func ellipse(at x: Int, _ y: Int, radius radiusH: Float, _ radiusV: Float, color: Color = Renderer.color) {
		DrawEllipseLines(x.toInt32, y.toInt32, radiusH, radiusV, color.toRaylib)
	}
	
	@inlinable public func ellipse(at position: Vector2f, radius: Vector2f, color: Color = Renderer.color) {
		DrawEllipseLines(position.x.toInt32, position.y.toInt32, radius.x, radius.y, color.toRaylib)
	}
	
	//MARK: Ring
	
	@inlinable public func ring(at x: Int, _ y: Int, inner innerRadius: Float, outer outerRadius: Float, segments: Int = 0, from start: Angle<Float>, to end: Angle<Float>, color: Color = Renderer.color) {
		DrawRingLines(Vector2f(x.toFloat, y.toFloat).toRaylib, innerRadius, outerRadius, start.toDegrees, end.toDegrees, segments.toInt32, color.toRaylib)
	}
	
	@inlinable public func ring(at position: Vector2f, inner innerRadius: Float, outer outerRadius: Float, segments: Int = 0, from start: Angle<Float>, to end: Angle<Float>, color: Color = Renderer.color) {
		DrawRingLines(position.toRaylib, innerRadius, outerRadius, start.toDegrees, end.toDegrees, segments.toInt32, color.toRaylib)
	}
	
	//MARK: Polygon
	
	@inlinable public func polygon(at x: Int, _ y: Int, sides: Int, radius: Float, rotation: Angle<Float> = .zero, color: Color = Renderer.color) {
		DrawPolyLines(Vector2f(x.toFloat, y.toFloat).toRaylib, sides.toInt32, radius, rotation.toDegrees, color.toRaylib)
	}
	
	@inlinable public func polygon(at position: Vector2f, sides: Int, radius: Float, rotation: Angle<Float> = .zero, color: Color = Renderer.color) {
		DrawPolyLines(position.toRaylib, sides.toInt32, radius, rotation.toDegrees, color.toRaylib)
	}
	
	//	@inlinable
	//	public func polygonOutline(_ shape: Polygon, thickness: Float, color: Color = Renderer.shapeColor) {
	//		DrawPolyLinesEx(shape.position, shape.sides.toInt32, shape.radius, shape.rotation.toDegrees, thickness, color)
	//	}
	
}

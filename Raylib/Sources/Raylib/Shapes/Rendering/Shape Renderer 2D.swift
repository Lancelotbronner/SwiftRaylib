//
//  File.swift
//  File
//
//  Created by Christophe Bronner on 2021-09-02.
//

import CRaylib

//MARK: - Shape Renderer

extension Renderer2D {
	
	//MARK: Triangle
	
	@inlinable public func triangle(_ p1: Vector2f, _ p2: Vector2f, _ p3: Vector2f, color: Color = Renderer.color) {
		DrawTriangle(p1.toRaylib, p2.toRaylib, p3.toRaylib, color.toRaylib)
	}
	
	@inlinable public func triangle(_ shape: Triangle, color: Color = Renderer.color) {
		DrawTriangle(shape.a.toRaylib, shape.b.toRaylib, shape.c.toRaylib, color.toRaylib)
	}
	
	//MARK: Rectangle
	
	@inlinable public func rectangle(at x: Int, _ y: Int, size width: Int, _ height: Int, color: Color = Renderer.color) {
		DrawRectangle(x.toInt32, y.toInt32, width.toInt32, height.toInt32, color.toRaylib)
	}
	
	@inlinable public func rectangle(at position: Vector2f, size: Vector2f, color: Color = Renderer.color) {
		DrawRectangle(position.x.toInt32, position.y.toInt32, size.x.toInt32, size.y.toInt32, color.toRaylib)
	}
	
	@inlinable public func rectangle(_ shape: Rectangle, color: Color = Renderer.color) {
		DrawRectangleRec(shape.toRaylib, color.toRaylib)
	}
	
	@inlinable public func rectangle(at x: Int, _ y: Int, size width: Int, _ height: Int, gradientH from: Color, _ to: Color) {
		DrawRectangleGradientH(x.toInt32, y.toInt32, width.toInt32, height.toInt32, from.toRaylib, to.toRaylib)
	}
	
	@inlinable public func rectangle(at position: Vector2f, size: Vector2f, gradientH from: Color, _ to: Color) {
		DrawRectangleGradientH(position.x.toInt32, position.y.toInt32, size.x.toInt32, size.y.toInt32, from.toRaylib, to.toRaylib)
	}
	
	@inlinable public func rectangle(_ shape: Rectangle, gradientH from: Color, _ to: Color) {
		DrawRectangleGradientH(shape.x.toInt32, shape.y.toInt32, shape.width.toInt32, shape.height.toInt32, from.toRaylib, to.toRaylib)
	}
	
	@inlinable public func rectangle(at x: Int, _ y: Int, size width: Int, _ height: Int, gradientV from: Color, _ to: Color) {
		DrawRectangleGradientV(x.toInt32, y.toInt32, width.toInt32, height.toInt32, from.toRaylib, to.toRaylib)
	}
	
	@inlinable public func rectangle(at position: Vector2f, size: Vector2f, gradientV from: Color, _ to: Color) {
		DrawRectangleGradientV(position.x.toInt32, position.y.toInt32, size.x.toInt32, size.y.toInt32, from.toRaylib, to.toRaylib)
	}
	
	@inlinable public func rectangle(_ shape: Rectangle, gradientV from: Color, _ to: Color) {
		DrawRectangleGradientV(shape.x.toInt32, shape.y.toInt32, shape.width.toInt32, shape.height.toInt32, from.toRaylib, to.toRaylib)
	}
	
	@inlinable public func rectangle(at x: Int, _ y: Int, size width: Int, _ height: Int, gradient topLeft: Color, _ bottomLeft: Color, _ bottomRight: Color, _ topRight: Color) {
		DrawRectangleGradientEx(.init(x: x.toFloat, y: y.toFloat, width: width.toFloat, height: height.toFloat), topLeft.toRaylib, bottomLeft.toRaylib, bottomRight.toRaylib, topRight.toRaylib)
	}
	
	@inlinable public func rectangle(at position: Vector2f, size: Vector2f, gradient topLeft: Color, _ bottomLeft: Color, _ bottomRight: Color, _ topRight: Color) {
		DrawRectangleGradientEx(.init(x: position.x, y: position.y, width: size.x, height: size.y), topLeft.toRaylib, bottomLeft.toRaylib, bottomRight.toRaylib, topRight.toRaylib)
	}
	
	@inlinable public func rectangle(_ shape: Rectangle, gradient topLeft: Color, _ bottomLeft: Color, _ bottomRight: Color, _ topRight: Color) {
		DrawRectangleGradientEx(shape.toRaylib, topLeft.toRaylib, bottomLeft.toRaylib, bottomRight.toRaylib, topRight.toRaylib)
	}
	
	//MARK: Rounded Rectangle
	
	@inlinable public func roundedRectangle(_ shape: RoundedRectangle, color: Color = Renderer.color) {
		DrawRectangleRounded(shape.frame.toRaylib, shape.cornerRadius, shape.segments.toInt32, color.toRaylib)
	}
	
	//MARK: Circle
	
	@inlinable public func circle(at x: Int, _ y: Int, radius: Float, color: Color = Renderer.color) {
		DrawCircle(x.toInt32, y.toInt32, radius, color.toRaylib)
	}
	
	@inlinable public func circle(at position: Vector2f, radius: Float, color: Color = Renderer.color) {
		DrawCircleV(position.toRaylib, radius, color.toRaylib)
	}
	
	@inlinable public func circle(_ shape: Circle, color: Color = Renderer.color) {
		DrawCircleV(shape.position.toRaylib, shape.radius, color.toRaylib)
	}
	
	@inlinable public func circle(at x: Int, _ y: Int, radius: Float, gradient from: Color, _ to: Color) {
		DrawCircleGradient(x.toInt32, y.toInt32, radius, from.toRaylib, to.toRaylib)
	}
	
	@inlinable public func circle(at position: Vector2f, radius: Float, gradient from: Color, _ to: Color) {
		DrawCircleGradient(position.x.toInt32, position.y.toInt32, radius, from.toRaylib, to.toRaylib)
	}
	
	@inlinable public func circle(_ shape: Circle, gradient from: Color, _ to: Color) {
		DrawCircleGradient(shape.position.x.toInt32, shape.position.y.toInt32, shape.radius, from.toRaylib, to.toRaylib)
	}
	
	//MARK: Sector
	
	@inlinable public func sector(at x: Int, _ y: Int, radius: Float, from start: Angle<Float>, to end: Angle<Float>, segments: Int = 0, color: Color = Renderer.color) {
		DrawCircleSector(Vector2f(x.toFloat, y.toFloat).toRaylib, radius, start.toDegrees, end.toDegrees, segments.toInt32, color.toRaylib)
	}
	
	@inlinable public func sector(at position: Vector2f, radius: Float, from start: Angle<Float>, to end: Angle<Float>, segments: Int = 0, color: Color = Renderer.color) {
		DrawCircleSector(position.toRaylib, radius, start.toDegrees, end.toDegrees, segments.toInt32, color.toRaylib)
	}
	
	//MARK: Ellipse
	
	@inlinable public func ellipse(at x: Int, _ y: Int, radius radiusH: Float, _ radiusV: Float, color: Color = Renderer.color) {
		DrawEllipse(x.toInt32, y.toInt32, radiusH, radiusV, color.toRaylib)
	}
	
	@inlinable public func ellipse(at position: Vector2f, radius: Vector2f, color: Color = Renderer.color) {
		DrawEllipse(position.x.toInt32, position.y.toInt32, radius.x, radius.y, color.toRaylib)
	}
	
	//MARK: Ring
	
	@inlinable public func ring(at x: Int, _ y: Int, inner innerRadius: Float, outer outerRadius: Float, segments: Int = 0, from start: Angle<Float>, to end: Angle<Float>, color: Color = Renderer.color) {
		DrawRing(Vector2f(x.toFloat, y.toFloat).toRaylib, innerRadius, outerRadius, start.toDegrees, end.toDegrees, segments.toInt32, color.toRaylib)
	}
	
	@inlinable public func ring(at position: Vector2f, inner innerRadius: Float, outer outerRadius: Float, segments: Int = 0, from start: Angle<Float>, to end: Angle<Float>, color: Color = Renderer.color) {
		DrawRing(position.toRaylib, innerRadius, outerRadius, start.toDegrees, end.toDegrees, segments.toInt32, color.toRaylib)
	}
	
	//MARK: Polygon
	
	@inlinable public func polygon(at x: Int, _ y: Int, sides: Int, radius: Float, rotation: Angle<Float> = .zero, color: Color = Renderer.color) {
		DrawPoly(Vector2f(x.toFloat, y.toFloat).toRaylib, sides.toInt32, radius, rotation.toDegrees, color.toRaylib)
	}
	
	@inlinable public func polygon(at position: Vector2f, sides: Int, radius: Float, rotation: Angle<Float> = .zero, color: Color = Renderer.color) {
		DrawPoly(position.toRaylib, sides.toInt32, radius, rotation.toDegrees, color.toRaylib)
	}
	
}

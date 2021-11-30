//
//  File.swift
//  File
//
//  Created by Christophe Bronner on 2021-09-07.
//

import CRaylib

//MARK: - Camera 3D

public struct Camera3D {
	
	//MARK: Properties
	
	@usableFromInline internal var underlying: CRaylib.Camera3D
	
	//MARK: Computed Properties
	
	/// Get view matrix
	@inlinable public var matrix: Matrix4x4f {
		GetCameraMatrix(underlying)
	}
	
	//MARK: Initialization
	
//	@inlinable public init(at position: Vector2f, offsetBy offset: Vector2f = Window.size / 2, rotation: Float = 0, zoom: Float = 1) {
//		underlying = .init
//	}
	
	//MARK: Methods
	
	/// Get the screen space position for a world space position
	@inlinable public func toScreen(world position: Vector3f) -> Vector2f {
		GetWorldToScreen(position, underlying)
	}
	
	/// Get the screen space position for a world space position
	@inlinable public func toScreen(world position: Vector3f, size width: Int, by height: Int) -> Vector2f {
		GetWorldToScreenEx(position, underlying, width.toInt32, height.toInt32)
	}
	
	// TODO: Ray hit
	// Ray GetMouseRay(Vector2 mousePosition, Camera camera);
	
	/// Begin 3D mode; End 3D mode
	@inlinable public func render(draw: () -> Void) {
		BeginMode3D(underlying)
		draw()
		EndMode3D()
	}
	
}
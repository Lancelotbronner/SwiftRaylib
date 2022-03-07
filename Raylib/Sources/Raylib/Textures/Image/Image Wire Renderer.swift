//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2022-01-12.
//

import CRaylib

//MARK: - Image Wire Renderer

public struct WireRendererImage {
	
	//MARK: Properties
	
	@usableFromInline var underlying: Image
	
	//MARK: Initialization
	
	@usableFromInline init(for image: Image) {
		underlying = image
	}
	
	//MARK: Rectangle Methods
	
	/// Draw rectangle lines within an image
	@inlinable public mutating func rectangle(_ shape: Rectangle, thickness: Int, color: Color) {
		withUnsafeMutablePointer(to: &underlying.implementation.raylib) { ptr in
			ImageDrawRectangleLines(ptr, shape.toRaylib, thickness.toInt32, color.toRaylib)
		}
	}
	
}

//
//  File.swift
//  File
//
//  Created by Christophe Bronner on 2021-09-07.
//

import CRaylib

//MARK: - Implementation of Image

public protocol ImplementationOfImage {
	
	var raylib: CRaylib.Image { get set }
	
}

extension ImplementationOfImage {
	
	@inlinable public var toSwift: Image {
		Image(self)
	}
	
}

//MARK: - Raylib Integration

extension CRaylib.Image: MemoryManageable {
	
	@inlinable public static func unload(instance: CRaylib.Image) {
		UnloadImage(instance)
	}
	
}

extension Unmanaged: ImplementationOfImage where Subject == CRaylib.Image { }
extension Managed: ImplementationOfImage where Subject == CRaylib.Image { }

extension Image {
	
	@inlinable public var toRaylib: CRaylib.Image {
		implementation.raylib
	}
	
}

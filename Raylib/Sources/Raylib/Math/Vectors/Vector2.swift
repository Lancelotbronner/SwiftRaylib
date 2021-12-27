//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2021-11-30.
//

import CRaylib

//MARK: - Vector 2

public typealias Vector2f = Vector2<Float>
public typealias Vector2i = Vector2<Int>

public struct Vector2<Scalar>: Vector {
	
	//MARK: Constants
	
	@inlinable public static var scalars: [WritableKeyPath<Vector2, Scalar>] {
		[\.x, \.y]
	}
	
	//MARK: Properties
	
	public var x: Scalar
	public var y: Scalar
	
	//MARK: Initialization
	
	@inlinable public init(_ x: Scalar, _ y: Scalar) {
		self.x = x
		self.y = y
	}
	
	@inlinable public init(_ v: Scalar) {
		self.init(v, v)
	}
	
	//MARK: Utilities
	
	@inlinable public static func map(_ transform: (WritableKeyPath<Vector2, Scalar>) throws -> Scalar) rethrows -> Vector2 {
		Vector2(try transform(\.x), try transform(\.y))
	}
	
}

//MARK: - Conformances

extension Vector2: Equatable where Scalar: Equatable { }
extension Vector2: Hashable where Scalar: Hashable { }

//MARK: - Raylib Integration

extension Vector2 where Scalar == Float {
	
	@_transparent public var toRaylib: CRaylib.Vector2 {
		CRaylib.Vector2(x: x, y: y)
	}
	
}

extension CRaylib.Vector2 {
	
	@_transparent public var toSwift: Vector2f {
		Vector2f(x, y)
	}
	
}

//MARK: - Trigonometry

extension Vector2 where Scalar: TrigonometryFunctions {
	
	@inlinable public func angle(with other: Self) -> Angle<Scalar> {
		var result = Angle.radians(Scalar.atan2(other.y - y, other.x - x))
		
		if result < .zero {
			result += .circle
		}
		
		return result
	}
	
}

/*
//----------------------------------------------------------------------------------
// Module Functions Definition - Vector2 math
//----------------------------------------------------------------------------------

// Calculate reflected vector to normal
RMAPI Vector2 Vector2Reflect(Vector2 v, Vector2 normal)
{
	Vector2 result = { 0 };
	
	float dotProduct = (v.x*normal.x + v.y*normal.y); // Dot product
	
	result.x = v.x - (2.0f*normal.x)*dotProduct;
	result.y = v.y - (2.0f*normal.y)*dotProduct;
	
	return result;
}

// Rotate vector by angle
RMAPI Vector2 Vector2Rotate(Vector2 v, float angle)
{
	Vector2 result = { 0 };
	
	result.x = v.x*cosf(angle) - v.y*sinf(angle);
	result.y = v.x*sinf(angle) + v.y*cosf(angle);
	
	return result;
}

// Move Vector towards target
RMAPI Vector2 Vector2MoveTowards(Vector2 v, Vector2 target, float maxDistance)
{
	Vector2 result = { 0 };
	
	float dx = target.x - v.x;
	float dy = target.y - v.y;
	float value = (dx*dx) + (dy*dy);
	
	if ((value == 0) || ((maxDistance >= 0) && (value <= maxDistance*maxDistance))) return target;
	
	float dist = sqrtf(value);
	
	result.x = v.x + dx/dist*maxDistance;
	result.y = v.y + dy/dist*maxDistance;
	
	return result;
}
*/
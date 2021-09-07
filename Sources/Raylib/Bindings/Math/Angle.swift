//
//  File.swift
//  File
//
//  Created by Christophe Bronner on 2021-09-04.
//

import CRaylib

//MARK: - Degree

public enum Angle {
	
	//MARK: Cases
	
	case zero
	case circle
	case degrees(Float)
	case radians(Float)
	
	//MARK: Computed Properties
	
	public var toDegrees: Float {
		switch self {
		case .zero: return 0
		case .circle: return 360
		case let .degrees(angle): return angle
		case let .radians(angle): return angle * 180 / .pi
		}
	}

	public var toRadians: Float {
		switch self {
		case .zero: return 0
		case .circle: return .pi * 2
		case let .degrees(angle): return angle * .pi / 180
		case let .radians(angle): return angle
		}
	}
	
}

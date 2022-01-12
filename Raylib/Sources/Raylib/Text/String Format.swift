//
//  File.swift
//  File
//
//  Created by Christophe Bronner on 2021-09-02.
//

import CRaylib
import Foundation
#warning("Remove or conditionalize Foundation dependency")

//MARK: - Floating Point Formatting

extension String.StringInterpolation {
	
	public mutating func appendInterpolation<T: CVarArg>(_ value: T, format: String) {
		appendLiteral(String(format: format, value))
	}
	
	public mutating func appendInterpolation<T: CVarArg & FloatingPoint>(_ value: T, decimals: Int, digits: Int? = nil) {
		appendLiteral(String(format: "%\(digits?.description ?? "").\(decimals)f", value))
	}
	
}

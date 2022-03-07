//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2022-01-18.
//

//MARK: - Timeline

public struct Timeline {
	
	//MARK: Properties
	
	@usableFromInline var counter: UInt32 = 0
	
	//MARK: Computed Properties
	
	@inlinable public var time: Int {
		counter.toInt
	}
	
	//MARK: Initialization
	
	@inlinable public init() { }
	
	//MARK: Configuration Methods
	
	@inlinable public mutating func update() {
		counter = counter &+ 1
	}
	
	//MARK: Check Methods
	
	@inlinable public func every(frames: Int) -> Bool {
		guard frames != 0 else { return false }
		assert(frames > 0, "The number of frames cannot be negative")
		return counter.toInt % frames == 0
	}
	
	@inlinable public func every(seconds: Double) -> Bool {
		every(frames: (Time.fps.toDouble * seconds).toInt)
	}
	
	@inlinable public func every(milliseconds: Int) -> Bool {
		every(seconds: milliseconds.toDouble / 1000)
	}
	
	//MARK: Block Methods
	
	@inlinable public func every(frames: Int, do block: () -> Void) {
		guard every(frames: frames) else { return }
		block()
	}
	
	@inlinable public func every(seconds: Double, do block: () -> Void) {
		guard every(seconds: seconds) else { return }
		block()
	}
	
	@inlinable public func every(milliseconds: Int, do block: () -> Void) {
		guard every(milliseconds: milliseconds) else { return }
		block()
	}
	
}

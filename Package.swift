// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Swift Raylib",
	products: [
		
		// Libraries
		
		.library(
			name: "SwiftRaylib",
			targets: ["Raylib"]),
		
	],
	targets: [
		
		// Raylib
		
		.systemLibrary(
			name: "CRaylib",
			path: "Sources/SystemRaylib",
			pkgConfig: "raylib",
			providers: [
				.brew(["raylib"]),
			]),
		
		// Bindings
		
			.target(
				name: "Raylib",
				dependencies: ["CRaylib"],
				path: "Sources/Bindings"),
		
		// Examples
		
			.executableTarget(
				name: "Example 01 - Core Basic Window",
				dependencies: ["Raylib"],
				path: "Examples/01 - Core Basic Window"),
		
			.executableTarget(
				name: "Example 02 - Core Input Keys",
				dependencies: ["Raylib"],
				path: "Examples/02 - Core Input Keys"),
		
			.executableTarget(
				name: "Example 03 - Core Input Mouse",
				dependencies: ["Raylib"],
				path: "Examples/03 - Core Input Mouse"),
		
			.executableTarget(
				name: "Example 04 - Core Input Mouse Wheel",
				dependencies: ["Raylib"],
				path: "Examples/04 - Core Input Mouse Wheel"),
		
			.executableTarget(
				name: "Example 08 - 2D Camera",
				dependencies: ["Raylib"],
				path: "Examples/08 - 2D Camera"),
		
			.executableTarget(
				name: "Example 09 - 2D Camera Platformer",
				dependencies: ["Raylib"],
				path: "Examples/09 - 2D Camera Platformer"),
		
		// Tests
		
			.testTarget(
				name: "RaylibTests",
				dependencies: ["Raylib"]),
	]
)

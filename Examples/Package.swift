// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//MARK: - Package

let package = Package(
	name: "Swift Raylib Examples",
	platforms: [
		.macOS(.v12),
	],
	dependencies: [
		
		// Wrappers
		.package(path: "../Raylib")
		
	],
	targets: [
		
		// Core Module
		.example(.core, "Basic Window"),
		.example(.core, "Input Keys"),
		.example(.core, "Input Mouse"),
		.example(.core, "Input Mouse Wheel"),
		.example(.core, "2D Camera"),
		.example(.core, "2D Camera Platformer"),
		.example(.core, "Letterboxed Window"),
		.example(.core, "Drop Files"),
		.example(.core, "Scissor Test"),
//		.example(.core, "3D First Person"),
		
		// Shapes Module
		.example(.shapes, "Basic Shapes"),
		.example(.shapes, "Bouncing Ball"),
		.example(.shapes, "Color Palette"),
		.example(.shapes, "Following Eyes"),
		
		// Textures Module
		.example(.textures, "Logo Raylib", [
			.copy("raylib_logo.png")
		]),
		.example(.textures, "Image Generation"),
		.example(.textures, "Blend Modes", [
			.copy("background.png"),
			.copy("foreground.png"),
		], ["LICENSE.md"]),
		
		// Classic Games
		.classic("Arkanoid"),
		.classic("Platformer"),
		.classic("Snake"),
		
		// Games
		.game("RPG Example", [
			.copy("Resources/Icons"),
			.copy("Resources/Levels"),
			.copy("Resources/Music"),
			.copy("Resources/Sounds"),
			.copy("Resources/tilemap.png"),
		]),
	]
)

//MARK: - Templates

extension Target {
	static func example(_ module: RaylibModule, _ name: String, _ resources: [Resource]? = nil, _ exclude: [String]? = nil) -> Target {
		let target = Target.executableTarget(
			name: "\(module.rawValue) - \(name)",
			dependencies: [
				.product(name: "SwiftRaylib", package: "Raylib"),
			],
			path: "Sources/\(module.rawValue)/\(name)",
			exclude: exclude ?? [],
			resources: resources)
		return target
	}
	
	static func classic(_ name: String, _ resources: [Resource]? = nil) -> Target {
		let target = Target.executableTarget(
			name: "Classic Game - \(name)",
			dependencies: [
				.product(name: "SwiftRaylib", package: "Raylib"),
			],
			path: "Sources/Classics/\(name)",
			resources: resources)
		return target
	}
	
	static func game(_ name: String, _ resources: [Resource]? = nil) -> Target {
		let target = Target.executableTarget(
			name: "Game - \(name)",
			dependencies: [
				.product(name: "SwiftRaylib", package: "Raylib"),
			],
			path: "Sources/Games/\(name)",
			resources: resources)
		return target
	}
}

//MARK: - Utilites

enum RaylibModule: String {
	case core = "Core"
	case shapes = "Shapes"
	case textures = "Textures"
}

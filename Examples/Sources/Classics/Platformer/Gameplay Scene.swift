//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2021-12-28.
//

import Raylib

//MARK: - Gameplay Scene

struct GameplayScene: Scene {
	
	//MARK: Constants
	
	let TILE_SIZE = 16
	let PLAYER_SIZE = Vector2f(8, 16)
	
	let MAX_SPEED: Float = 1.5625 * 60
	let ACCELERATION: Float = 0.118164 * 60 * 60
	let DECCELERATION: Float = 0.113281 * 60 * 60
	let GRAVITY: Float = 0.363281 * 60 * 60
	let JUMP_IMPULSE: Float = -6.5625 * 60
	
	//MARK: Properties
	
	var level: Map
	let numberOfCoins: Int
	
	var position: Vector2f
	var subpixel = Vector2f.zero
	var velocity = Vector2f.zero
	var isGrounded = false
	var score = 0
	
	var camera: Camera2D
	
//	var maximumSpeed: Float
//	var acceleration: Float
//	var decceleration: Float
//	var gravity: Float
//	var jumpImpulse: Float
//	var jumpRelease: Float
//	var velocity: Vector2f
//
//	var isGrounded: Bool
//	var isJumping: Bool
//	var hitOnFloor: Bool
//	var hitOnCeiling: Bool
//	var hitOnWall: Bool

//	player.jumpRelease = player.jumpImpulse*0.2f;
	
	//MARK: Initialization
	
	init(for level: Map) {
		self.level = level
		position = (level.spawn * Map.TILE_SIZE).map(\.toFloat)
		camera = Camera2D(at: .zero)
		
		numberOfCoins = level.tiles.reduce(into: 0) { count, tile in
			count += tile == .coin ? 1 : 0
		}
	}
	
	//MARK: Simulation Methods
	
	mutating func update() -> SceneAction {
		// Detect wether you are grounded this frame
		ground()
		
		// Modify velocity based on player controls
		movement()
		jump()
		
		// Modify velocity based on game conditions
		environment()
		collisions()
		
		// Collect if overlapping
		collect()
		
		// Apply velocity to player
		apply()
		
		// Check for win conditions
		if score == numberOfCoins {
			return .dismiss // TODO: Replace with GameOver
		}
		
		return .continue
	}
	
	mutating func ground() {
		guard !isGrounded else { return }
		
		let x = position.x.toInt
		let y = position.y.toInt
		
		let (tileX, pixelX) = x.quotientAndRemainder(dividingBy: Map.TILE_SIZE)
		let (tileY, pixelY) = y.quotientAndRemainder(dividingBy: Map.TILE_SIZE)
		
		guard
			let ground = level[tileX, tileY].top(at: pixelX, pixelY),
			y <= ground
		else { return }
		
		isGrounded = true
	}
	
	mutating func movement() {
		var direction: Float = 0
		
		if [Keyboard.a, Keyboard.left].anyDown {
			direction -= 1
		}
		
		if [Keyboard.d, Keyboard.right].anyDown {
			direction += 1
		}
		
		if direction != 0 {
			velocity.x += direction * ACCELERATION * Time.delta
			velocity.x.clamp(between: -MAX_SPEED, and: MAX_SPEED)
			
		} else {
			let dcc = DECCELERATION * Time.delta
			if abs(velocity.x) < dcc {
				velocity.x = 0
			} else {
				velocity.x += velocity.x < 0 ? -dcc : dcc
			}
		}
	}
	
	mutating func jump() {
		guard isGrounded, Keyboard.space.isDown else { return }
		isGrounded = false
		velocity.y = JUMP_IMPULSE
	}
	
	mutating func environment() {
		if !isGrounded {
			velocity.y += GRAVITY * Time.delta
			velocity.y.maximum(of: -JUMP_IMPULSE)
		}
	}
	
	mutating func collisions() {
		let speed = velocity * Time.delta + subpixel

		if speed.x > 0 {
			testForHorizontalCollision(offset: +, if: >=, to: Tile.left, sort: min)
		} else {
			testForHorizontalCollision(offset: -, if: <=, to: Tile.right, sort: max)
		}
		
		if speed.y > 0 {
			testForVerticalCollision(offset: -, if: <=, to: Tile.bottom, sort: max)
		} else {
			testForVerticalCollision(offset: +, if: >=, to: Tile.top, sort: min)
		}
	}
	
	mutating func collect() {
		let tile = (position / 16).map(\.toInt)
		
		switch level[tile] {
		case .coin:
			level[tile] = .empty
			score += 1
			
		case .empty, .block: break
		}
	}
	
	mutating func apply() {
		let speed = (velocity * Time.delta + subpixel).map {
			$0.rounded(.towardZero)
		}
		
		subpixel = velocity * Time.delta - speed
		position += speed
		
		let sizeOfLevel = level.size.map(\.toFloat) * Map.TILE_SIZE.toFloat
		position.clamp(between: .zero, and: sizeOfLevel)
	}
	
	//MARK: Drawing Methods
	
	func draw(using renderer: Renderer2D) {
//		camera.render {
			level.iterate { position, tile in
				switch tile {
				case .block:
					let tmp = position * Map.TILE_SIZE
					renderer.rectangle(at: tmp.x, tmp.y, size: Map.TILE_SIZE, Map.TILE_SIZE, color: .gray)
					
				case .coin:
					let tmp = position * Map.TILE_SIZE + Map.TILE_SIZE / 2 - 2
					renderer.circle(at: tmp.x, tmp.y + 6, radius: 2, color: .gold)
					
				case .empty: break
				}
			}
			
			renderer.rectangle(at: Vector2f(position.x - PLAYER_SIZE.x / 2, position.y - PLAYER_SIZE.y), size: PLAYER_SIZE, color: .red)
//		}
		
		renderer.text("SCORE: \(score)", at: Window.width / 2, 50, size: 40, alignment: .center, color: .black)
	}
	
	//MARK: Utilities
	
	mutating func testForHorizontalCollision(
		offset: (Float, Float) -> Float,
		if comparison: (Int, Int) -> Bool,
		to edge: (Tile) -> (Int, Int) -> Int?,
		sort: (Int, Int) -> Int
	) {
		let speed = velocity.x * Time.delta + subpixel.x
		let (tileX, pixelX) = (offset(position.x, PLAYER_SIZE.x / 2) + speed).toInt.quotientAndRemainder(dividingBy: Map.TILE_SIZE)
		let pixelY = position.y.toInt % Map.TILE_SIZE
		var hit: Int? = nil
		
		for tileY in [position.y, position.y - PLAYER_SIZE.y / 2, position.y + PLAYER_SIZE.y / 2] {
			let tile = level[tileX, tileY.toInt / Map.TILE_SIZE]
			guard let limit = edge(tile)(pixelX, pixelY), comparison(pixelX, limit) else { return }
			hit = hit.map { sort($0, limit) } ?? limit
		}
		
		guard let collision = hit else { return }
		position.x = collision.toFloat
		velocity.x = 0
		subpixel.x = 0
	}
	
	mutating func testForVerticalCollision(
		offset: (Float, Float) -> Float,
		if comparison: (Int, Int) -> Bool,
		to edge: (Tile) -> (Int, Int) -> Int?,
		sort: (Int, Int) -> Int
	) {
		let speed = velocity.y * Time.delta + subpixel.x
		let (tileY, pixelY) = (offset(position.y, PLAYER_SIZE.y / 2) + speed).toInt.quotientAndRemainder(dividingBy: Map.TILE_SIZE)
		let pixelX = position.x.toInt % Map.TILE_SIZE
		var hit: Int? = nil
		
		for tileX in [position.x, position.x - PLAYER_SIZE.x / 2, position.x + PLAYER_SIZE.x / 2] {
			let tile = level[tileX.toInt / Map.TILE_SIZE, tileY]
			guard let limit = edge(tile)(pixelX, pixelY), comparison(pixelY, limit) else { return }
			hit = hit.map { sort($0, limit) } ?? limit
		}
		
		guard let collision = hit else { return }
		position.y = collision.toFloat
		velocity.y = 0
		subpixel.y = 0
	}
	
}

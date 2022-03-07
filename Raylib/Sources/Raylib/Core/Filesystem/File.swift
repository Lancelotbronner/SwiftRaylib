//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2021-11-24.
//

import CRaylib

//MARK: - File

public struct File {
	
	//MARK: Properties
	
	public let path: String
	
	//MARK: Computed Properties
	
	/// Check if file exists
	@inlinable public var exists: Bool {
		FileExists(path)
	}
	
	/// Get filename
	@inlinable public var filename: String {
		GetFileName(path).toString
	}
	
	/// Get filename string without extension
	@inlinable public var name: String {
		GetFileNameWithoutExt(path).toString
	}
	
	/// Get extension for a filename string (includes dot: '.png')
	@inlinable public var `extension`: String {
		GetFileExtension(path).toString
	}
	
	/// Get file modification time (last write time)
	@inlinable public var modification: Int {
		GetFileModTime(path)
	}
	
	@inlinable public var directory: Directory {
		Directory(at: GetDirectoryPath(path).toString)
	}
	
	/// Load text data from file
	@inlinable public var text: String? {
		guard let pointer = LoadFileText(path) else {
			return nil
		}
		defer { UnloadFileText(pointer) }
		return pointer.toString
	}
	
	///  Load file data as byte array
	@inlinable public var bytes: [UInt8]? {
		var count: UInt32 = 0
		guard let pointer = LoadFileData(path, &count) else {
			return nil
		}
		defer { UnloadFileData(pointer) }
		return Array(UnsafeMutableBufferPointer(start: pointer, count: count.toInt))
	}
	
	//MARK: Initialization
	
	@usableFromInline init(at path: Path) {
		self.path = path
	}
	
	//MARK: Methods
	
	/// Check file extension (including point: .png, .wav)
	@inlinable public func `is`(extension ext: String) -> Bool {
		IsFileExtension(path, ext)
	}
	
	//MARK: Reading Methods
	
	/// Load file as image
	@inlinable public func loadAsImage() -> Image {
		LoadImage(path.description).toManaged.toSwift
	}
	
	/// Load raw file data as image
	@inlinable public func loadAsRawImage(size width: Int, by height: Int, format: PixelFormat, offset: Int) -> Image {
		LoadImageRaw(path.description, width.toInt32, height.toInt32, format.toRaylib.toInt32, offset.toInt32).toManaged.toSwift
	}
	
	/// Load file as animation
	@inlinable public func loadAsAnimation(frames: Int) -> Image {
		var frames = frames.toInt32
		return LoadImageAnim(path.description, &frames).toManaged.toSwift
	}
	
	/// Load file as texture
	@inlinable public func loadAsTexture() -> Texture {
		LoadTexture(path.description).toManaged
	}
	
	//MARK: Writing Methods
	
	/// Save text data to file
	@inlinable public func write(text: String) throws {
		_ = text.withCString { pointer in
			SaveFileText(path, UnsafeMutablePointer(mutating: pointer))
		}
		// TODO: Handle error
	}
	
	/// Save data to file
	@inlinable public func write(data: [UInt8]) throws {
		_ = data.withUnsafeBytes { buffer in
			SaveFileData(path, UnsafeMutableRawPointer(mutating: buffer.baseAddress), buffer.count.toUInt32)
		}
		// TODO: Handle error
	}
	
	@inlinable public func write(image: Image) {
		// TODO: Error Handling
		ExportImage(image.implementation.raylib, path.description)
	}
	
}

//MARK: - Foundation Integration

#if canImport(Foundation)
import Foundation

extension File {
	
	///  Load file data
	@inlinable public var data: Data? {
		var count: UInt32 = 0
		guard let pointer = LoadFileData(path, &count) else {
			return nil
		}
		defer { UnloadFileData(pointer) }
		return Data(buffer: UnsafeMutableBufferPointer(start: pointer, count: count.toInt))
	}
	
	/// Load file as JSON
	@inlinable public func loadAsJSON<T: Decodable>(of entity: T.Type = T.self, using decoder: JSONDecoder = .init()) throws -> T? {
		guard let data = data else { return nil }
		return try decoder.decode(T.self, from: data)
	}
	
	/// Save json data to file
	@inlinable public func write<T: Encodable>(json entity: T, using encoder: JSONEncoder = .init()) throws {
		try write(data: Array(encoder.encode(entity)))
	}
	
}
#endif

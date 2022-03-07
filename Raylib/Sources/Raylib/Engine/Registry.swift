
//MARK: - Registry

public struct Registry<Kind> {
	
	//MARK: Properties
	
	@usableFromInline var ids: [String : Int] = [:]
	@usableFromInline var loaded: [Kind] = []
	
	//MARK: Initialization
	
	public init() { }
	
	//MARK: Methods
	
	/// Allows you to register a resource using an identifier
	///
	/// The resource will be assigned an internal ID which you can retrieve using ``lookup(_:)``.
	///
	/// - Parameters:
	///   - resource: The resource to register
	///   - identifier: The identifier with which the resource will be registered
	@discardableResult
	@inlinable public mutating func register(_ resource: Kind, for identifier: String) -> Int {
		ids[identifier] = loaded.count
		defer { loaded.append(resource) }
		return loaded.count
	}
	
	@inlinable public func retrieve(_ id: Int) -> Kind {
		loaded[id]
	}
	
	@inlinable public func contains(_ identifier: String) -> Bool {
		ids.keys.contains(identifier)
	}
	
	@inlinable public func lookup(_ identifier: String) -> Int? {
		ids[identifier]
	}

	//MARK: Utilities
	
	@inlinable public mutating func reserveCapacity(_ minimumCapacity: Int) {
		loaded.reserveCapacity(minimumCapacity)
	}
	
	@inlinable public mutating func reserveAdditionalCapacity(_ additionalCapacity: Int) {
		loaded.reserveCapacity(loaded.capacity + additionalCapacity)
	}
	
}

//
//  File.swift
//  
//
//  Created by Christophe Bronner on 2021-12-29.
//

import ArgumentParser
import Foundation
import AppKit

struct DocumentationCommand: ParsableCommand {
	
	//MARK: Constants
	
	static let configuration = CommandConfiguration(
		commandName: "docs",
		abstract: "Documentation commands"
	)
	
	//MARK: Methods
	
	// TODO: Header Parsing
	// - Comments above declarations should be parsed as documentation
	// - Asides as comments above declarations should be owned by the symbol
	
	// TODO: Cleanup Map
	// - rename to "repair-map"
	// - Handle regex search and replace
	
	// TODO: Symbol Map
	// - first column: "Declaration" for C symbol
	// - second column: "Interpretation" for behavior
	//     * "bind" to indicate swift symbol will follow
	//     * "managed" to indicate symbol is managed
	//     * "std" to indicate symbol is replaced by Standard Library methods
	//     * "ignore" to ignore the symbol, removing it from the document
	// - third column: "Bindings" for swift symbols
	// - Move ignore logic from program to symbol map
	
	// TODO: Processing
	// - Replace C comment symbols with Swift symbol link
	// - Move string literal to template file using replace tokens instead (as %TOKEN%)
	//		* CONTENT
	//		? TABLE_OF_CONTENTS
	//		* RAYLIB_VERSION
	//		* COVERAGE
	//		* NUMBER_OF_SYMBOLS
	//		* NUMBER_OF_BINDINGS
	
	// TODO: Rendering
	// - Reduce the amount of characters
	// - Table of Contents?
	
	// TODO: Misc
	// - Separate steps into methods
	// - Produce JSON metadata of API
	
	mutating func run() throws {
		var stopwatch = Stopwatch()
		
		// Load files
		
		print("Loading resources...")
		
		let raylibURL = unwrap(
			optional: Bundle.module.path(forResource: "raylib", ofType: "h"),
			failure: "Coudn't find local header, is \"raylib.h\" it added to package resources?",
			placeholder: "")
		
		let symbolMapURL = unwrap(
			optional: Bundle.module.path(forResource: "symbol-map", ofType: "csv"),
			failure: "Coudn't find symbol map, is \"symbols-map.csv\" it added to package resources?",
			placeholder: "")
		
		let cleanupMapURL = unwrap(
			optional: Bundle.module.path(forResource: "cleanup-map", ofType: "csv"),
			failure: "Coudn't find cleanup map, is \"cleanup-map.csv\" it added to package resources?",
			placeholder: "")
		
		ensureNoError("locating resources")
		
		let header = try String(contentsOfFile: raylibURL)
		
		let linesOfHeader = header.components(separatedBy: .newlines).compactMap { line -> [String]? in
			let words = line.components(separatedBy: .whitespaces).compactMap { word in
				word.isEmpty ? nil : word
			}
			
			return words.isEmpty ? nil : words
		}
		
		let contentsOfSymbolMap = try String(contentsOfFile: symbolMapURL).components(separatedBy: .newlines).dropFirst()
		let contentsOfCleanupMap = try String(contentsOfFile: cleanupMapURL).components(separatedBy: .newlines).dropFirst()
		
		print("Loaded resources in \(stopwatch.microsecondsInMilliseconds)ms")
		
		// Find raylib version
		
		stopwatch.reset()
		print("Finding header version...")
		
		guard let rangeOfVersionDefine = header.range(of: "#define RAYLIB_VERSION") else {
			fatalError("Coudn't find raylib version define, we're looking for a line starting like such: \"#define RAYLIB_VERSION\"")
		}
		
		guard let nextEndOfLine = header[rangeOfVersionDefine.upperBound...].firstIndex(of: "\n") else {
			fatalError("Unexpected end of file while looking for raylib version define")
		}
		
		let version = header[rangeOfVersionDefine.upperBound ..< nextEndOfLine]
			.trimmingCharacters(in: .alphanumerics.union(CharacterSet(charactersIn: ".-")).inverted)
		
		print("Found raylib v\(version) in \(stopwatch.microsecondsInMilliseconds)ms")
		
		// Reading cleanup map
		
		stopwatch.reset()
		print("Reading cleanup map...")
		var cleanupComment: [String : String?] = [:]
		
		for i in contentsOfCleanupMap.indices {
			let line = contentsOfCleanupMap[i]
			guard !line.isEmpty else { continue }
			let components = line.components(separatedBy: "|").map {
				$0.trimmingCharacters(in: .whitespaces)
			}
			
			guard components.count == 3 else {
				report("Invalid entry at line \(i + 2): \(line)")
				continue
			}
			
			switch components[0] {
			case "comment": cleanupComment[components[1]] = components[2].isEmpty ? nil : components[2]
			default: report("Invalid scope at line \(i + 2): \(components[0])")
			}
		}
		
		func clean(comment: inout String) {
			for (key, value) in cleanupComment {
				while let range = comment.range(of: key) {
					comment.replaceSubrange(range, with: value ?? "")
				}
			}
		}
		
		ensureNoError("in cleanup entries")
		print("Registered \(cleanupComment.count) comment cleanup entries in \(stopwatch.microsecondsInMilliseconds)ms")
		
		// Reading symbol map
		
		stopwatch.reset()
		print("Reading symbol map...")
		var symbols: [String : [String]] = [:]
		
		for i in contentsOfSymbolMap.indices {
			let line = contentsOfSymbolMap[i]
			guard !line.isEmpty else { continue }
			let components = line.components(separatedBy: "|").map {
				$0.trimmingCharacters(in: .whitespaces)
			}
			
			guard components.count == 2 else {
				report("Invalid entry at line \(i + 2): \(line)")
				continue
			}
			
			var tmp = components[1]
				.components(separatedBy: ",")
				.map { $0.trimmingCharacters(in: .whitespaces) }
			
			if tmp.count == 1, tmp[0].isEmpty {
				tmp.removeFirst()
			}
			
			symbols[components[0]] = tmp
		}
		
		ensureNoError("in symbol entries")
		print("Registered \(symbols.count) symbol entries in \(stopwatch.microsecondsInMilliseconds)ms")

		// Parsing header file
		
		stopwatch.reset()
		print("Parsing header file...")

		var components: [Component] = []
		var totalNumberOfSymbols = 0
		var coverage = 0
		
		func bindings(for symbol: String) -> [String]? {
			guard let tmp = symbols[symbol] else {
				print("\tMissing symbol: \(symbol)")
				return nil
			}
			
			coverage += 1
			return tmp
		}
		
		func append(symbol title: String, c declaration: String, _ documentation: String? = nil) {
			totalNumberOfSymbols += 1
			components.append(.symbol(Symbol(title: title, documentation: documentation, declaration: declaration, bindings: bindings(for: title))))
		}
		
		func isAside(_ line: [String]) -> String? {
			let range = line[1 ..< min(line.count, 4)]
			if range.contains(where: { $0.contains("NOTE") }) {
				return "Note"
			}
			if range.contains(where: { $0.contains("WARNING") }) {
				return "Warning"
			}
			return nil
		}
		
		var i = 0
		var line: [String] { linesOfHeader[i] }
		
		while i < linesOfHeader.count {
			if ["/*", "*"].contains(where: line[0].hasPrefix) {
				i += 1
				continue
			}
			
			if ["#endif", "extern", "#include", "#if", "#ifndef", "#elif", "#else", "}"].contains(line[0]) {
				i += 1
				continue
			}
			
			if line[0].hasPrefix("//---") {
				i += 1
				let title = line.dropFirst().joined(separator: " ")
				components.append(.module(Module(title: title)))
				i += 2
				continue
			}
			
			switch line[0] {
			case "#define":
				if ["RAYLIB_H", "RLAPI", "PI", "DEG2RAD", "RAD2DEG"].contains(line[1]) || line[1].contains("(") || line[1].hasPrefix("RL_") {
					break
				}
				
				append(symbol: line[1], c: "#define \(line[1]);")
				
			case "typedef":
				switch line[1] {
				case "struct":
					guard line.contains("{") else { break }
					append(symbol: line[2], c: "struct \(line[2]);")
					
					repeat { i += 1 }
					while !line.contains("}")
					
				case "enum":
					guard !["bool"].contains(line[2]) else { break }
					
					var cases: [(String, String?)] = []
					i += 1
					
					while line[0] != "}" {
						let title = line[0].trimmingCharacters(in: .alphanumerics.inverted)
						var documentation: String? = nil
						
						if let indexOfComment = line.firstIndex(of: "//") {
							var comment = line[line.index(after: indexOfComment)...].joined(separator: " ")
							clean(comment: &comment)
							documentation = comment
						}
						
						if !title.isEmpty {
							cases.append((title, documentation))
						}
						
						i += 1
					}
					
					let type = line[1].trimmingCharacters(in: .alphanumerics.inverted)
					
					for (name, comment) in cases.reversed() {
						append(symbol: name, c: "\(type) \(name);", comment)
					}
					
				default:
					let end = line.firstIndex(of: "//") ?? line.endIndex
					guard end == 3 else { break }
					
					let title = line[2].trimmingCharacters(in: .alphanumerics.inverted)
					let declaration = line[0..<3].joined(separator: " ")
					append(symbol: title, c: declaration)
				}
				
			case "RLAPI":
				guard let indexOfDocumentation = line.firstIndex(where: { $0.contains("//") }) else {
					fatalError("Function missing its documentation")
				}
				
				guard let indexOfName = line.firstIndex(where: { $0.contains("(") }) else {
					fatalError("Function missing its name")
				}
				
				let title = line[indexOfName].prefix { $0 != "(" }.components(separatedBy: .alphanumerics.inverted).joined()
				var documentation = line[line.index(after: indexOfDocumentation)...].joined(separator: " ")
				let declaration = "\(line[1]) \(line[2 ..< indexOfDocumentation].joined(separator: " "))"
				clean(comment: &documentation)
				append(symbol: title, c: declaration, documentation)
				
			case "//":
				let aside = isAside(line)
				var content = line.dropFirst().joined(separator: " ")
				i += 1
				
				while line[0] == "//" && isAside(line) == nil {
					content.append(" ")
					content.append(line.dropFirst(2).joined(separator: " "))
					i += 1
				}
				
				if let category = aside, let indexOfColon = content.firstIndex(of: ":") {
					content = content[content.index(after: indexOfColon)...].trimmingCharacters(in: .whitespaces)
					components.append(.aside(Aside(category: category, content: content)))
					
				} else {
					content = content.trimmingCharacters(in: .whitespaces)
					components.append(.section(Group(title: content)))
				}
				continue
				
			default:
				fatalError("Line \(i) could not be processed")
			}
			
			i += 1
		}
		
		print("Parsed and cleaned \(components.count) document components in \(stopwatch.microsecondsInMilliseconds)ms")
		
		// Filter Document
		
		stopwatch.reset()
		print("Filtering and populating components...")
		
		let before = components.count
		var declarationsOfSymbols: [(String, String?)] = []
		var declarationsOfGroups: [Group] = []
		var asides: [Int] = []
		
		i = components.count - 1
		while i >= 0 {
			switch components[i] {
			case var .module(value):
				if declarationsOfGroups.isEmpty && declarationsOfSymbols.isEmpty {
					asides.forEach { components.remove(at: $0) }
					components.remove(at: i)
					break
				}
				
				value.groups = declarationsOfGroups.reversed()
				components[i] = .module(value)
				
				declarationsOfGroups = []
				asides = []
				
			case var .section(value):
				if declarationsOfSymbols.isEmpty {
					asides.forEach { components.remove(at: $0) }
					components.remove(at: i)
					break
				}
				
				if declarationsOfSymbols.count == 1 {
					if let indexOfSymbol = components[i...].firstIndex(where: {
						if case .symbol = $0 {
							return true
						}
						return false
					}) {
						if case var .symbol(valueOfSymbol) = components[indexOfSymbol] {
							valueOfSymbol.documentation = valueOfSymbol.documentation ?? value.title
							components[indexOfSymbol] = .symbol(valueOfSymbol)
						}
					}
					
					components.remove(at: i)
					declarationsOfSymbols = []
					break
				}
				
				value.symbols = declarationsOfSymbols.reversed()
				components[i] = .section(value)
				
				declarationsOfGroups.append(value)
				declarationsOfSymbols = []
				asides = []
				
			case let .symbol(value):
				declarationsOfSymbols.append((value.declaration, value.documentation))
				asides = []
				
			case .aside:
				asides.append(i)
			}
			
			i -= 1
		}
		
		print("Populated \(components.count) components and filtered out \(before - components.count) useless components in \(stopwatch.microsecondsInMilliseconds)ms")
		
		// Rendering Document
		
		stopwatch.reset()
		print("Rendering document...")
		
		let coveragePercentage = Int(Double(coverage) / Double(totalNumberOfSymbols) * 100)
		
		var document = """
			# Cheatsheet

			**raylib v\(version)    |    bindings \(coveragePercentage)%**

			This document presents a detailed overview of the raylib cheatsheet along with its corresponding Swift symbol(s).

			This document currently has a \(coveragePercentage)% coverage, contributions are welcome!

			> Note: This file is generated (and badly so), any improvement suggestions are welcome.
		"""
		
		document.append("\n\n")
		for component in components {
			print(component.debugDescription, terminator: "\n\n")
			
			switch component {
			case let .module(value):
				document.append("## \(value.title)\n\n")
				
			case let .section(value):
				document.append("### \(value.title)\n\n")
				document.append("```mm\n")
				let width = value.symbols.map(\.declaration.count).max() ?? 0
				for (declaration, documentation) in value.symbols {
					document.append(declaration)
					if let doc = documentation {
						document.append(String(repeating: " ", count: width - declaration.count + 1))
						document.append("// ")
						document.append(doc)
					}
					document.append("\n")
				}
				document.append("```\n\n")
				
			case let .symbol(value):
				document.append("#### \(value.title)\n\n")
				document.append(value.documentation ?? "This symbol has no documentation")
				document.append("\n\nLanguage | Symbol\n --- | ---\n")
				document.append("C | `\(value.declaration)`\n")
				document.append("Swift | ")
				
				switch value.bindings {
				case let .some(swift):
					document.append(swift.map { "``\($0)``" }.formatted())
					
				case []:
					document.append("-")
					
				default:
					document.append("*unimplemented*")
				}
				
				document.append("\n\n")
				
			case let .aside(value):
				document.append("> \(value.category): \(value.content)\n\n")
			}
		}
		
		print("Document rendered in \(stopwatch.microsecondsInMilliseconds)ms")
		
		// Copy to clipboard
		
		print("Result copied to clipboard")
		NSPasteboard.general.clearContents()
		NSPasteboard.general.setString(document, forType: .string)
	}
	
	//MARK: Utilities
	
	private var errors: [String] = []
	
	private mutating func report(_ error: String) {
		errors.append(error)
	}
	
	private mutating func unwrap<T>(optional value: T?, failure: String, placeholder: T) -> T {
		guard let tmp = value else {
			report(failure)
			return placeholder
		}
		return tmp
	}
	
	private func ensureNoError(_ activity: String) {
		guard !errors.isEmpty else { return }
		let description = errors.map { "\n\t\($0)" }
		fatalError("One or more errors \(activity): \(description)")
	}
	
}

//MARK: - Structures

enum Component: CustomStringConvertible, CustomDebugStringConvertible {
	case module(Module)
	case section(Group)
	case symbol(Symbol)
	case aside(Aside)
	
	var description: String {
		switch self {
		case let .module(value): return "[ \(value.title) ]"
		case let .section(value): return "# \(value.title)"
		case let .aside(value): return "> \(value.category): \(value.content)"
		case let .symbol(value): return value.title
		}
	}
	
	var debugDescription: String {
		switch self {
		case let .module(value): return "[ \(value.title) ]"
		case let .section(value): return "# \(value.title)"
		case let .aside(value): return "\t> \(value.category): \(value.content)"
		case let .symbol(value):
			var tmp = value.title
			tmp += String(repeating: " ", count: 38 - value.title.count)
			tmp += "// "
			tmp += value.documentation ?? "This symbol has no documentation"
			tmp += "\n\t    C\t\(value.declaration)"
			tmp += "\n\tSwift\t\(value.bindings?.joined(separator: ", ") ?? "-")"
			return tmp
		}
	}
}

struct Module {
	var title: String
	var groups: [Group] = []
}

struct Group {
	var title: String
	var symbols: [(declaration: String, documentation: String?)] = []
}

struct Symbol {
	var title: String
	var documentation: String? = nil
	var declaration: String
	var bindings: [String]? = nil
}

struct Aside {
	var category: String
	var content: String
}

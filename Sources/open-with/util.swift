// Thanks to Sindre Sorhus for these utilities
// https://github.com/sindresorhus/do-not-disturb/blob/master/Sources/do-not-disturb/util.swift
import Cocoa

func sleep(for duration: TimeInterval) {
	usleep(useconds_t(duration * Double(USEC_PER_SEC)))
}

extension FileHandle: TextOutputStream {
	public func write(_ string: String) {
		write(string.data(using: .utf8)!)
	}
}

extension NSImage {
	func resize(w: Int, h: Int) -> NSImage? {
		let size = NSMakeSize(CGFloat(w), CGFloat(h));
		// Create a new rect with given width and height
		let frame = NSMakeRect(0, 0, size.width, size.height)

		// Get the best representation for the given size.
		guard let rep = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
				return nil
		}

		// Create an empty image with the given size.
		let img = NSImage(size: size)

		// Set the drawing context and make sure to remove the focus before returning.
		img.lockFocus()
		defer { img.unlockFocus() }

		// Draw the new image
		if rep.draw(in: frame) {
				return img
		}

		// Return nil in case something went wrong.
		return nil
	}
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
}

struct CLI {
	static var standardInput = FileHandle.standardInput
	static var standardOutput = FileHandle.standardOutput
	static var standardError = FileHandle.standardError

	static let arguments = Array(CommandLine.arguments.dropFirst(1))
}

enum PrintOutputTarget {
	case standardOutput
	case standardError
}

/// Make `print()` accept an array of items
/// Since Swift doesn't support spreading...
private func print<Target>(
	_ items: [Any],
	separator: String = " ",
	terminator: String = "\n",
	to output: inout Target
) where Target: TextOutputStream {
	let item = items.map { "\($0)" }.joined(separator: separator)
	Swift.print(item, terminator: terminator, to: &output)
}

func print(
	_ items: Any...,
	separator: String = " ",
	terminator: String = "\n",
	to output: PrintOutputTarget = .standardOutput
) {
	switch output {
	case .standardOutput:
		print(items, separator: separator, terminator: terminator)
	case .standardError:
		print(items, separator: separator, terminator: terminator, to: &CLI.standardError)
	}
}

// swift-tools-version:5.0
import PackageDescription

let package = Package(
	name: "open-with",
	platforms: [
		.macOS(.v10_10)
	],
	targets: [
		.target(
			name: "open-with"
		)
	]
)

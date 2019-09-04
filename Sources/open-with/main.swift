import Cocoa

switch CLI.arguments.first {
  case "apps-for-file":
    print(OpenWith.urlsForAppsThatOpenFile(CLI.arguments[1]))
  case "apps-for-type":
    print(OpenWith.urlsForAppsThatOpenType(CLI.arguments[1]))
  case "open":
    OpenWith.open(CLI.arguments[1], applicationUrl: CLI.arguments[2])
  default:
    print("Unsupported command", to: .standardError)
    exit(1)
}

import Cocoa

switch CLI.arguments.first {
  case "apps-for-extension":
    print(OpenWith.urlsForAppsThatOpenExtension(CLI.arguments[1]))
  case "apps-for-file":
    print(OpenWith.urlsForAppsThatOpenFile(URL(fileURLWithPath: CLI.arguments[1])))
  case "apps-for-type":
    print(OpenWith.urlsForAppsThatOpenType(CLI.arguments[1]))
  case "open":
    OpenWith.open(CLI.arguments[1], withAppAtUrl: CLI.arguments[2])
  default:
    print("Unsupported command", to: .standardError)
    exit(1)
}

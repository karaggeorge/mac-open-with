import Cocoa

public struct OpenWith {
  static func urlsForAppsThatOpenFile(_ filePath: String, role: LSRolesMask = [.viewer, .editor]) -> String {
    let url = NSURL.fileURL(withPath: filePath)
    let typeIdentifier = url.typeIdentifier!
    return urlsForAppsThatOpenType(typeIdentifier, role: role)
  }

  static func urlsForAppsThatOpenType(_ typeIdentifier: String, role: LSRolesMask = [.viewer, .editor]) -> String {
    let returnValue = LSCopyAllRoleHandlersForContentType(typeIdentifier as CFString, role)?.takeUnretainedValue() as? [String] ?? []
		return toJson(returnValue.compactMap { NSWorkspace.shared.urlForApplication(withBundleIdentifier: $0) })
  }

  static func toJson(_ urls: [URL]) -> String {
    do {
      let data = urls.map { "\($0)" }
      let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
      let json = String(data: jsonData, encoding: String.Encoding.utf8)
      return json!
    } catch {
      return "[]"
    }
  }

  static func open(_ filePath: String, applicationUrl: String) {
    do {
      try NSWorkspace.shared.open([NSURL.fileURL(withPath: filePath)], withApplicationAt: URL(string: applicationUrl)!, configuration: [:])
    } catch {
      print(error, to: .standardError)
    }
  }
}
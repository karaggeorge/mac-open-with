import Cocoa

public struct OpenWith {
  static func urlsForAppsThatOpenFile(_ filePath: String, role: LSRolesMask = .all, withIcons: Bool = true) -> String {
    let url = NSURL.fileURL(withPath: filePath)
    let appUrls = LSCopyApplicationURLsForURL(url as CFURL, .all)?.takeUnretainedValue() as? [URL] ?? []
    let defaultAppUrl = LSCopyDefaultApplicationURLForURL(url as CFURL, .all, nil)?.takeUnretainedValue() as URL?

    let appList = appUrls.map {
      [
        "url": $0.absoluteString,
        "isDefault": $0.absoluteString.isEqual(defaultAppUrl!.absoluteString)
      ]
    }
    return toJson(withIcons ? addIconsToAppList(appList) : appList)
  }

  static func urlsForAppsThatOpenType(_ typeIdentifier: String, role: LSRolesMask = .all, withIcons: Bool = true) -> String {
    let appIdentifiers = LSCopyAllRoleHandlersForContentType(typeIdentifier as CFString, role)?.takeUnretainedValue() as? [String] ?? []
    let defaultAppIdentifier = LSCopyDefaultRoleHandlerForContentType(typeIdentifier as CFString, role)?.takeUnretainedValue() as! String

    let appList = appIdentifiers.map {
      [
        "url": NSWorkspace.shared.urlForApplication(withBundleIdentifier: $0)?.absoluteString,
        "isDefault": $0.isEqual(defaultAppIdentifier)
      ]
    }
    return toJson(withIcons ? addIconsToAppList(appList) : appList)
  }

  static func urlsForAppsThatOpenExtension(_ ext: String, role: LSRolesMask = .all, withIcons: Bool = true) -> String {
    let directory = NSTemporaryDirectory();
    let fileName = NSUUID().uuidString + "." + ext;
    let fullUrl = NSURL.fileURL(withPathComponents: [directory, fileName]);

    do {
      try "".write(to: fullUrl!, atomically: false, encoding: .utf8);
    } catch {
      return "[]"
    }

    return urlsForAppsThatOpenFile(fullUrl?.path as! String, role: role, withIcons: withIcons);
  }

  static func getIconFromAppUrl(_ url: String) -> String {
    let icon = NSWorkspace.shared.icon(forFile: url).tiffRepresentation!
    let bitmap = NSBitmapImageRep(data: icon);
    let data = bitmap?.representation(using: .png, properties: [:]);
    return "data:image/png;base64,\(data!.base64EncodedString())"
  }

  static func addIconsToAppList(_ appList: [[String:Any]]) -> [[String:Any]] {
    return appList.map {
      [
        "url": $0["url"],
        "isDefault": $0["isDefault"],
        "icon": getIconFromAppUrl($0["url"] as! String)
      ]
    }
  }

  static func toJson(_ data: [[String:Any]]) -> String {
    do {
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
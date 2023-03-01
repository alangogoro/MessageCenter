//
//  Extensino.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/2/20.
//

import UIKit

// MARK: - String Extension
extension Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        self == nil || self == ""
    }
    
}

// MARK: - Data Extension
extension Data {
    
    var prettyJSON: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object,
                                                     options: [.prettyPrinted]),
              let string = String(data: data, encoding: .utf8) else { return nil }
        return string
    }
    
    func printSize() {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useKB]
        bcf.countStyle = .file
        let size = bcf.string(fromByteCount: Int64(self.count))
        print("→ Data formatted size: \(size). bytesCount: \(self.count)")
    }
    
}

// MARK: - UIView Extension
extension UIView {
    
    func addSubview(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
        
    }
    
}

// MARK: - UIAlertController
extension UIAlertController {
    
    static func samplePresent() {
        guard let windowScene = UIApplication.shared.windows
            .first(where: { $0.isKeyWindow })?.windowScene else { return }
        
        let alertWindow = UIWindow(windowScene: windowScene)
        alertWindow.frame = UIScreen.main.bounds
        alertWindow.backgroundColor = .clear
        alertWindow.windowLevel = .alert
        alertWindow.rootViewController = UIViewController()
        alertWindow.makeKeyAndVisible()
        
        let alertController = UIAlertController(title: "Alert", message: nil,
                                                preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default) { action in
            // retain alertView reference within this handler, then release the window as handler finished
            _ = alertWindow
        }
        alertController.addAction(doneAction)
        
        alertWindow.rootViewController?.present(alertController, animated: true)
    }
    
    static func present(title: String, message: String? = nil,
                        actionTitle: String? = nil, actionStyle: UIAlertAction.Style = .default,
                        completion: @escaping (Bool) -> Void) {
        guard let windowScene = UIApplication.shared.windows
            .first(where: { $0.isKeyWindow })?.windowScene else { return }
            
        let alertWindow = UIWindow(windowScene: windowScene)
        alertWindow.frame = windowScene.screen.bounds
        alertWindow.backgroundColor = .clear
        alertWindow.windowLevel = .alert
        alertWindow.rootViewController = UIViewController()
        
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle ?? "確認", style: actionStyle) { action in
            completion(true)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { cancel in
            completion(false)
        }
        alertController.addAction(action)
        alertController.addAction(cancel)
        
        alertWindow.rootViewController?.present(alertController, animated: true)
    }
    
}

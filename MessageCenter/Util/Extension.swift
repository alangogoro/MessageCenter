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
extension UIColor {
    static let purple = UIColor(105, 40, 187)
    static let peachy = UIColor(255, 20, 116)
    static let darkBlack = UIColor(6, 6, 6)
    static let toolGray = UIColor(61, 61, 61)
    static let notice = UIColor(179, 179, 179)
    
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ a : CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
    
}

// MARK: - UserDefaults
class UserDefaultsHelper {
    
    static let defaults = UserDefaults.standard
        
    static func set(value: Any, forKey key: String) {
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }
    
    static func get(forKey key: String) -> Any? {
        defaults.value(forKey: key)
    }
    
}

extension UIView {
    
    func addSubview(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
        
    }
    
    // MARK: AutoLayout
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func center(inView view: UIView, xConstant: CGFloat = 0, yConstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xConstant).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let leftAnchor = leftAnchor {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: paddingLeft).isActive = true
        }
    }
    
    func setDimensions(width: CGFloat?, height: CGFloat?) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setConstraintsEqualsView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func setDimensionsEqualTo(width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil,
                              widthMultiplier: CGFloat = 1.0, heightMultiplier: CGFloat = 1.0,
                              widthConstant: CGFloat = 1.0, heightConstant: CGFloat = 1.0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalTo: width, multiplier: widthMultiplier, constant: widthConstant).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalTo: height, multiplier: heightMultiplier, constant: heightConstant).isActive = true
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

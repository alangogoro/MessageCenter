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
    static let backgroundBlack = UIColor(16, 16, 16)
    static let backgroundGray = UIColor(29, 31, 32)
    static let toolGray = UIColor(61, 61, 61)
    static let wordGray = UIColor(63, 70, 77)
    static let silverGray = UIColor(129, 144, 159)
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
        
    static func presentAlert(title: String, message: String? = nil,
                             actioinTitle: String? = "確認", actionStyle: UIAlertAction.Style = .default,
                             cancellable: Bool = true,
                             completion: ((Bool) -> Void)? = nil) {
        guard var topController = UIApplication.shared.windows
            .first(where: { $0.isKeyWindow })?.rootViewController else { return }
        while let presented = topController.presentedViewController {
            topController = presented
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.setAttributedTitle([.font: UIFont.boldSystemFont(ofSize: 20)],
                                           [.foregroundColor: UIColor.wordGray])
        
        let action = UIAlertAction(title: actioinTitle, style: actionStyle) { action in
            completion?(true)
        }
        action.titleTextColor = .peachy
        alertController.addAction(action)
        
        let cancel = UIAlertAction(title: "取消", style: .cancel) { cancel in
            completion?(false)
        }
        cancel.titleTextColor = .silverGray
        if cancellable {
            alertController.addAction(cancel)
        }
        
        topController.present(alertController, animated: true)
    }
    
    func setAttributedTitle(_ attributes: [NSAttributedString.Key: Any]...) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)
        
        for attribute in attributes {
            attributeString.addAttributes(attribute, range: NSMakeRange(0, title.count))
        }
        
        self.setValue(attributeString, forKey: "attributedTitle")
    }
    
    func setAttributedMessage(_ attributes: [NSAttributedString.Key: Any]...) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        
        for attribute in attributes {
            attributeString.addAttributes(attribute, range: NSMakeRange(0, message.count))
        }
        
        self.setValue(attributeString, forKey: "attributedMessage")
    }
    
}

extension UIAlertAction {
    
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
    
}

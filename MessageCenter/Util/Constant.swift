//
//  Constant.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/2/20.
//

import UIKit

// MARK: - UI constants
var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

var statusBarHeight: CGFloat {
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}

// MARK: - FCM - Firebase Cloud Messaging constant
struct FCMKeys {
    static let messageId = "gcm.message_id"
}

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

// MARK: - Firebase Cloud Message
struct FCMKeys {
    static let messageId = "gcm.message_id"
}

// MARK: - DeepLink
struct DeepLink {
    static let domain = "https://talkmate.page.link"
    static let appStoreID = "1563126232"
    static let bundleID = "tw.com.cfd.Voxy"
    
    struct Keys {
        static let routeSign = "route_sign"
        static let gender = "gender"
        static let link = "link"
    }
    
    struct Values {
        static let route = "18"
        static let femaleGender = "2"
    }
}

struct LoginParameter {
    struct Values {
        static let OSType = "2"
    }
}

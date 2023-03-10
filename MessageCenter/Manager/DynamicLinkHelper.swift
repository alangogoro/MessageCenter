//
//  DynamicLinkHelper.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/9.
//

import Foundation
import FirebaseDynamicLinks


class DynamicLinkHelper {
    
    static func createDeepLink(for token: String) -> URL? {
        // https://msgcntr.page.link/29hQ
        var components = URLComponents()
        components.scheme = "https"
        components.host = "talkmate.page.link"
        components.path = "/"
        
        let routeSignItem = URLQueryItem(name: DeepLink.Keys.routeSign, value: DeepLink.Values.route)
        let genderItem    = URLQueryItem(name: DeepLink.Keys.gender, value: DeepLink.Values.femaleGender)
        let fastToken     = token
        let linkItem      = URLQueryItem(name: DeepLink.Keys.link, value: fastToken)
        let debugItem     = URLQueryItem(name: "d", value: "1")
        components.queryItems = [routeSignItem, genderItem, linkItem, debugItem]
        guard let link = components.url else { return nil }
        
        guard let linkBuilder = DynamicLinkComponents.init(link: link,
                                                           domainURIPrefix: DeepLink.domain) else { return nil }
        //if let bundleID = Bundle.main.bundleIdentifier { ..
        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: DeepLink.bundleID)
        linkBuilder.iOSParameters?.appStoreID = DeepLink.appStoreID
        guard let longURL = linkBuilder.url else { return nil }
        Logger.debug("⭐️ long link:", longURL.absoluteString)
        return longURL
        
        // ===== Manually construct =====
        let deep_link = "https://talkmate.page.link/"
        let ios_bundle_id = DeepLink.bundleID
        let app_store_id  = DeepLink.appStoreID
        let dynamicLink   = "https://talkmate.page.link/?link=" + deep_link +
        "&ibi=" + ios_bundle_id +
        "&isi=\(app_store_id)" +
        "&route_sign=\(DeepLink.Values.route)" +
        "&gender=\(DeepLink.Values.femaleGender)" +
        "&link=\(fastToken)"
        let dynamicLink_debug = dynamicLink + "&d=1"
        debugPrint("Debug dynamic = ", dynamicLink_debug)
        Logger.debug("⭐️ dynamic link:", dynamicLink)
        return URL(string: dynamicLink) ?? nil
        
        /*
        linkBuilder.shorten { (url, warnings, error) in
            if let error = error {
                print("🔴 Oh no! Got an error! \(error)")
                return
            }
            if let warnings = warnings {
                warnings.forEach {
                    print("🟡 Warning: \($0)")
                }
            }
            guard let shortURL = url else { return }
            print("⭐️short link: \(shortURL.absoluteString)")
        }
         */
    }
    
}

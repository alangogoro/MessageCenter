//
//  HomeTVCViewModel.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/7.
//

import Combine
import FirebaseMessaging
import FirebaseDynamicLinks
import FirebaseAnalytics


class HomeTVCViewModel {
    // MARK: - Properties
    private let deviceToken = CurrentValueSubject<String, Never>("")
    private let userList = CurrentValueSubject<[ListData], Never>([])
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    init() {
        setupSubscriptions()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleFCMToken(notification:)),
                                               name: Notification.Name("FCM Token"),
                                               object: nil)
    }
    
    @objc
    private func handleFCMToken(notification: Notification) {
        if let userInfo = notification.userInfo,
           let fcmToken = userInfo["fcmToken"] as? String {
            pushToken = fcmToken
            self.deviceToken.value = fcmToken
        }
    }
    
    fileprivate func setupSubscriptions() {
        deviceToken.sink { token in
            Task {
                let loginData = await self.login()
                self.setFAUserName(loginData?.name)
                
                if let loginToken = loginData?.sessionToken {
                    sessionToken = loginToken
                    Logger.info("session-token:", sessionToken)
                    
                    if let userList = await self.getList() {
                        self.userList.value = userList
                        Logger.info("userList:" , userList.map { "\($0.name ?? "N/A")"} )
                    }
                }
            }
        }.store(in: &subscriptions)
        
        userList.sink { users in
            // TODO: TableView dataSource
            self.createDeepLink(users)
        }.store(in: &subscriptions)
    }
    
    // MARK: - API
    private func login() async -> LoginData? {
        guard !pushToken.isNilOrEmpty else { return nil }
        return await PostManager.shared.login(with: "aaaa", password: "bbbb")
    }
    
    private func getList() async -> [ListData]? {
        guard !sessionToken.isNilOrEmpty else { return nil }
        return await PostManager.shared.getList()
    }
    
    // MARK: - Deep Link
    private func createDeepLink(_ users: [ListData]) {
        // https://msgcntr.page.link/29hQ
        var components = URLComponents()
        components.scheme = "https"
        components.host = "talkmate.page.link"
        components.path = "/"
        
        let routeSignItem = URLQueryItem(name: DeepLink.Keys.routeSign, value: DeepLink.Values.route)
        let genderItem    = URLQueryItem(name: DeepLink.Keys.gender, value: DeepLink.Values.femaleGender)
        let fastToken     = users.first?.fastToken ?? "N/A"
        let linkItem      = URLQueryItem(name: DeepLink.Keys.link, value: fastToken)
        let debugItem     = URLQueryItem(name: "d", value: "1")
        components.queryItems = [routeSignItem, genderItem, linkItem, debugItem]
        guard let link = components.url else { return }
        
        guard let linkBuilder = DynamicLinkComponents.init(link: link,
                                                           domainURIPrefix: DeepLink.domain) else { return }
        //if let bundleID = Bundle.main.bundleIdentifier { ..
        linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: DeepLink.bundleID)
        linkBuilder.iOSParameters?.appStoreID = DeepLink.appStoreID
        guard let longURL = linkBuilder.url else { return }
        Logger.debug("⭐️ long link:\t", longURL.absoluteString)
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(longURL) {
                UIApplication.shared.open(longURL, options: [:])
            }
        }
        
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
        Logger.debug("⭐️ dynamic link:\t", dynamicLink)
        DispatchQueue.main.async {
            //if let url = URL(string: dynamicLink), UIApplication.shared.canOpenURL(url) {
            //    UIApplication.shared.open(url, options: [:])
            //}
        }
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
            
            if UIApplication.shared.canOpenURL(shortURL) {
                UIApplication.shared.open(shortURL, options: [:])
            }
        }
         */
    }
    
    
    // MARK: - FirebaseAnalytics
    private func setFAUserName(_ name: String?) {
        guard !name.isNilOrEmpty else { return }
        FirebaseAnalytics.Analytics.setUserProperty(name, forName: "Name")
    }
    
}

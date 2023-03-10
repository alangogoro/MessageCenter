//
//  MainListViewModel.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/7.
//

import Combine
import FirebaseMessaging
import FirebaseAnalytics


class MainListViewModel {
    // MARK: - Properties
    let userList = CurrentValueSubject<[ListData], Never>([])
    private let deviceToken = CurrentValueSubject<String, Never>("")
    private var subscriptions = Set<AnyCancellable>()
    
    private let postManager: PostManager
    
    // MARK: - Lifecycle
    init(post: PostManager) {
        self.postManager = post
//        setupSubscriptions()
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(handleFCMToken(notification:)),
//                                               name: Notification.Name("FCM Token"),
//                                               object: nil)
    }
    
    public func getUserList() {
        Task {
            let users = await postManager.getList()
            if let users {
                self.userList.value = users
            }
        }
    }
    
    @objc
    private func handleFCMToken(notification: Notification) {
        if let userInfo = notification.userInfo,
           let fcmToken = userInfo["fcmToken"] as? String {
            UserDefaultsHelper.set(value: fcmToken, forKey: .pushToken)
            self.deviceToken.value = fcmToken
        }
    }
    
    fileprivate func setupSubscriptions() {
        deviceToken.sink { token in
            Task {
//                let loginData = await self.login()
//                self.setFAUserName(loginData?.name)
//
//                if let loginToken = loginData?.sessionToken {
//                    UserDefaultsHelper.set(value: loginToken, forKey: .sessionToken)
//                    Logger.info("session-token:", loginToken)
//
//                    if let userList = await self.getList() {
//                        self.userList.value = userList
//                        Logger.info("userList:" , userList.map { "\($0.name ?? "N/A")"} )
//                    }
//                }
            }
        }.store(in: &subscriptions)
    }
    
    // MARK: - API
    private func getList() async -> [ListData]? {
        let sessionToken = UserDefaultsHelper.get(forKey: .sessionToken)
        guard !sessionToken.isNilOrEmpty else { return nil }
        return await PostManager.shared.getList()
    }
    
    // MARK: - FirebaseAnalytics
    private func setFAUserName(_ name: String?) {
        guard !name.isNilOrEmpty else { return }
        FirebaseAnalytics.Analytics.setUserProperty(name, forName: "Name")
    }
    
}

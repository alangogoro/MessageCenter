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
    let errorPublisher = PassthroughSubject<Bool, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    private let postManager: PostManager
    
    // MARK: - Lifecycle
    init(post: PostManager) {
        self.postManager = post
    }
    
    public func getUserList() {
        Task {
            let users = await postManager.getList()
            if let users {
                self.userList.value = users
            }
            errorPublisher.send(users == nil || self.userList.value.isEmpty)
        }
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

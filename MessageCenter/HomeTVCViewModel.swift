//
//  HomeTVCViewModel.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/7.
//

import Combine
import FirebaseMessaging

class HomeTVCViewModel {
    // MARK: - Properties
    private let deviceToken = CurrentValueSubject<String, Never>("")
    private let userList = CurrentValueSubject<[ListData], Never>([])
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    init() {
        deviceToken.sink { [weak self] token in
            pushToken = token
            self?.login()
        }.store(in: &subscriptions)
        userList.sink { users in
            
        }.store(in: &subscriptions)
        
        Task {
            let deviceToken = try await Messaging.messaging().token()
            self.deviceToken.value = deviceToken
        }
    }
    
    private func login() {
        guard !pushToken.isEmpty else { return }
        
        Task {
            let data = await PostManager.shared.login()
            Logger.info("name:", data?.sessionToken ?? "N/A")
            
            if let data {
                sessionToken = data.sessionToken
                
                let userList = await PostManager.shared.getList()
                guard let userList else { return }
                self.userList.value = userList
                
                Logger.info("userList:" , userList.map { "\($0.name ?? "N/A")"} )
            }
        }
    }
}

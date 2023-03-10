//
//  LoginVCViewModel.swift
//  MessageCenter
//
//  Created by usr on 2023/3/9.
//

class LoginVCViewModel {
    private let postManager: PostManager
    
    init(post: PostManager) {
        self.postManager = post
    }
    
    public func login(account: String, password: String) async -> Bool {
        let result = await postManager.login(withAccount: account, password: password)
        if let sessionToken = result?.sessionToken {
            UserDefaultsHelper.set(value: sessionToken, forKey: .sessionToken)
        }
        return result != nil
    }
    
}

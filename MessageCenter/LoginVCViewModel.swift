//
//  LoginVCViewModel.swift
//  MessageCenter
//
//  Created by usr on 2023/3/9.
//

class LoginVCViewModel {
    public let maxTextCount = 50
    private let postManager: PostManager
    
    init(post: PostManager) {
        self.postManager = post
    }
    
    public func login(account: String, password: String) async -> Bool {
        let data = await postManager.login(withAccount: account, password: password)
        if let sessionToken = data?.sessionToken {
            UserDefaultsHelper.set(value: data?.name ?? "", forKey: .loginName)
            UserDefaultsHelper.set(value: sessionToken, forKey: .sessionToken)
        }
        return data != nil
    }
    
    public func checkInputs(_ string1: String?, _ string2: String?) -> Bool {
        // TODO: 待處理驗證
        guard let string1, let string2 else { return false }
        return string1.count >= 4 && string2.count >= 4
    }
    
}

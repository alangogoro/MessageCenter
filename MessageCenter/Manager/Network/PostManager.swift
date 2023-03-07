//
//  PostManager.swift
//  MessageCenter
//
//  Created by usr on 2023/2/21.
//

class PostManager {
    static let shared = PostManager()
    
    // MARK: - Login
    public func login() async -> LoginData? {
        let login = LoginRequest(acc: "aaaa", pwd: "bbbb")
        do {
            let response = try await Networking.request(from: .login, parameter: login,
                                                        receiveModel: LoginResponse.self)
            return response.status ? response.data : nil
        } catch {
            Logger.error("Login error:", error)
            return nil
        }
    }
    
    public func getList() async -> [ListData]? {
        do {
            let response = try await Networking.request(from: .getList,
                                                        receiveModel: ListResponse.self)
            return response.status ? response.data : nil
        } catch {
            Logger.error("GetList error:", error)
            return nil
        }
    }
}

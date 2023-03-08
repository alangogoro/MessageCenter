//
//  PostManager.swift
//  MessageCenter
//
//  Created by usr on 2023/2/21.
//

class PostManager {
    static let shared = PostManager()
    
    // MARK: Login
    public func login(with account: String, password: String) async -> LoginData? {
        let login = LoginRequest(acc: account, pwd: password)
        do {
            let response = try await Networking.request(from: .login, parameter: login,
                                                        receiveModel: LoginResponse.self)
            return response.status ? response.data : nil
        } catch {
            Logger.error("Login error:", error)
            return nil
        }
    }
    
    // MARK: Logout
    public func logout() async -> Bool {
        do {
            let response = try await Networking.request(from: .logout,
                                                        receiveModel: LoginResponse.self)
            return response.status
        } catch {
            Logger.error("Logout error:", error)
            return false
        }
    }
    
    // MARK: Get list
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

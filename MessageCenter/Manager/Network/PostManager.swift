//
//  PostManager.swift
//  MessageCenter
//
//  Created by usr on 2023/2/21.
//

import Alamofire


class PostManager {
    enum PostError: Error {
        case requestError(String)
        case aferror(AFError)
    }
    
    static let shared = PostManager()
    
    // MARK: Login
    public func login(withAccount account: String, password: String) async -> LoginData? {
        let login = LoginRequest(acc: account, pwd: password,
                                 os_type: LoginParameter.Values.OSType)
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
    public func logout() async -> Result<LoginResponse, PostError> {
        do {
            let response = try await Networking.request(from: .logout,
                                                        receiveModel: LoginResponse.self)
            if response.status {
                return .success(response)
            } else {
                return .failure(.requestError(response.message))
            }
        } catch {
            Logger.error("Logout error:", error)
            return .failure(.aferror(error as! AFError))
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

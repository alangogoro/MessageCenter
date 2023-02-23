//
//  ReceiveModel.swift
//  MessageCenter
//
//  Created by usr on 2023/2/20.
//

// MARK: - Login Model
struct LoginRequest: Encodable {
    let acc: String
    let pwd: String
}

struct LoginResponse: Decodable {
    let status: Bool
    let message: String
    let data: LoginData?
    
    enum CodingKeys: CodingKey {
        case status, message, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(Bool.self, forKey: .status) ?? false
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try? container.decodeIfPresent(LoginData.self, forKey: .data) ?? nil
    }
}
struct LoginData: Decodable {
    let id: String
    let sessionToken: String
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case sessionToken = "session_token"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        sessionToken = try container.decodeIfPresent(String.self, forKey: .sessionToken) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? nil
    }
}

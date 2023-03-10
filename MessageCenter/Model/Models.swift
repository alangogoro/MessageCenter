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
        data = try container.decodeIfPresent(LoginData.self, forKey: .data) ?? nil
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

// MARK: - List Model
struct ListResponse: Decodable {
    let status: Bool
    let message: String
    let data: [ListData]?
    
    enum CodingKeys: CodingKey {
        case status, message, data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(Bool.self, forKey: .status) ?? false
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try container.decodeIfPresent([ListData].self, forKey: .data) ?? nil
    }
}

struct ListData: Decodable, Hashable {
    /// 淘妹用戶ID
    let userId: String
    /// 用戶UID
    let uid: String
    let name: String?
    let profilePic: String?
    let unread: String?
    /// 快速登入token
    let fastToken: String
    let canLogin: String?
    let lastInfo: LastChatData?
    
    enum CodingKeys: String, CodingKey {
        case name, uid, unread
        case userId = "user_id"
        case profilePic = "profile_pic"
        case fastToken = "fast_token"
        case canLogin = "can_login"
        case lastInfo = "last_user_info"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? ""
        uid = try container.decodeIfPresent(String.self, forKey: .uid) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? nil
        profilePic = try container.decodeIfPresent(String.self, forKey: .profilePic) ?? nil
        unread = try container.decodeIfPresent(String.self, forKey: .unread) ?? nil
        fastToken = try container.decodeIfPresent(String.self, forKey: .fastToken) ?? ""
        canLogin = try container.decodeIfPresent(String.self, forKey: .canLogin) ?? nil
        lastInfo = try container.decodeIfPresent(LastChatData.self, forKey: .lastInfo) ?? nil
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    
    static func == (lhs: ListData, rhs: ListData) -> Bool {
        return lhs.uid == rhs.uid
    }
}

struct LastChatData: Decodable {
    let uid: String
    let name: String
    let pic: String?
    let type: String
    let content: String?
    let createDt: String
    
    enum CodingKeys: String, CodingKey {
        case name, uid, type, content
        case pic = "profile_pic"
        case createDt = "create_dt"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decodeIfPresent(String.self, forKey: .uid) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        pic = try container.decodeIfPresent(String.self, forKey: .pic) ?? nil
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        content = try container.decodeIfPresent(String.self, forKey: .content) ?? nil
        createDt = try container.decodeIfPresent(String.self, forKey: .createDt) ?? ""
    }
}

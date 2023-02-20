//
//  URL.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/2/20.
//

import Foundation
import Alamofire

enum ApiURL: String, URLConvertible {
    var path: String {
        get {
            let domain = "http://172.105.228.202/voxy/msg/"
            return domain + self.rawValue
        }
    }
    // 註冊
    case login = "login.php"
    
    func asURL() throws -> URL {
        guard let url = URL(string: self.rawValue) else {
            throw AFError.invalidURL(url: self)
        }
        return url
    }
}

enum SocketURL: String {
    case productionSocket = "wss://chat.horofriend88.com:8185"
    case testSocket = "wss://webrtc-voxy.cfd888.info:8186"
}

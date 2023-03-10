//
//  URL.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/2/20.
//

import Foundation
import Alamofire

enum ApiURL: String {
    var path: String {
        get {
            let domain = "http://172.105.228.202/voxy/msg/"
            return domain + self.rawValue
        }
    }
    // 註冊
    case login = "login.php"
    case logout = "logout.php"
    case getList = "get_list.php"
}

extension ApiURL: URLConvertible {
    func asURL() throws -> URL {
        guard let url = URL(string: self.rawValue) else {
            throw AFError.invalidURL(url: self)
        }
        return url
    }
}

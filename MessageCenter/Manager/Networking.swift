//
//  Networking.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/2/20.
//

import Foundation
import Alamofire

class Networking {
    
    static let shared = Networking()
    
    func request<T, U>(from url: ApiURL,
                       parameter: T? = nil, receiveModel: U.Type) async where T: Encodable, U: Decodable {
        let task = AF.request(url.path,
                              method: .post,
                              parameters: ["acc": "aaaa", "pwd": "bbbb"], encoder: .json,
                              interceptor: RetryPolicy()).serializingDecodable(receiveModel)
        let response = await task.response
        let result = await task.result
        let value = try? await task.value
    }
    
    func dkApi<T: Decodable>(url: ApiURL,
                             parameter: [String: Any]? = nil,
                             model: T.Type) {
        // 若每個 API 有相對低的差異，可在此判斷處理
        // 整理 API URL 及參數，再呼叫 request
        
        Self.dkRequest(from: "URL stirng",
                     //HTTPMethod: .GET,
                     //contentType: ContentType = .query,
                     parameter: parameter) { (data, response, url, error) in
            // 處理 response，轉換 model
        }
    }

    static func dkRequest(from url: String,
                        //HTTPMethod: HTTPMethod,
                        //contentType: ContentType,
                        parameter: [String: Any]?,
                        completion: ((Data?, URLResponse?, URL, Error?) -> Void)?) {
        // 設定 Header、處理每種 content type 或 http method
        
    }
    
}

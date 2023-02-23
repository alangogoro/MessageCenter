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
    
    static func request<T, U>(from url: ApiURL,
                              parameter: T? = nil, receiveModel: U.Type) async throws -> U where T: Encodable, U: Decodable {
        let token = #"SESSION_TOKEN"#
        let headers: HTTPHeaders = [
            .init(name: "session-token", value: token),
            .accept("application/json")
        ]
        let task = AF.request(url.path,
                              method: .post,
                              parameters: parameter, encoder: URLEncodedFormParameterEncoder.urlEncodedForm(destination: .httpBody),
                              headers: headers, interceptor: RetryPolicy())
            .validate(statusCode: 200..<300)
        //  .validate(contentType: ["application/json"])
            .serializingDecodable(receiveModel)
        let result = await task.result
        switch result {
        case .success:
            return try await task.value
        case let .failure(error):
            throw error
        }
    }
    
    func dkStyledApi<T: Decodable>(url: ApiURL,
                                   parameter: [String: Any]? = nil,
                                   model: T.Type) {
        // 若每個 API 有相對低的差異，可在此判斷處理
        // 整理 API URL 及參數，再呼叫 static func request
        Self.dkStyledRequest(from: "URL stirng",
                             httpMethod: .get,
                             //contentType: ContentType = .query,
                             parameter: parameter) { (data, response, url, error) in
            // 處理 response，轉換 model
        }
    }

    static func dkStyledRequest(from url: String,
                                httpMethod: HTTPMethod,
                                //contentType: ContentType = .query,
                                parameter: [String: Any]?,
                                completion: ((Data?, URLResponse?, URL, Error?) -> Void)?) {
        // 設定 Header、處理每種 content type 或 http method
        
    }
}

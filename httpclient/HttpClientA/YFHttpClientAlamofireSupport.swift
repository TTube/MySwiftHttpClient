//
//  YFHttpClientAlamofireSupport.swift
//  httpclient
//
//  Created by 陈嘉维 on 2017/8/28.
//  Copyright © 2017年 yff. All rights reserved.
//

import Foundation
import Alamofire


extension YFHttpMethod {
    func alamoMethod() -> HTTPMethod {
        switch self {
        case .get:
            return .get
        case .delete:
            return .delete
        case .head:
            return .head
        case .post:
            return .post
        case .put:
            return .put
        case .options:
            return .options
        }
    }
}


extension RequestEncryptType {
    func key() -> Data? {
        return Data()
    }
}

struct YFJSONEncoding: YFRequestEncoder {
    
    func encode(_ urlRequest: URLRequest, with parameters: YFHttpParameters?) throws -> URLRequest {
        return try JSONEncoding.default.encode(urlRequest, with: parameters)
    }
    
}

struct YFEncryptEncoding: YFRequestEncoder {
    var key: Data?
    
    init(_ key: Data?) {
        self.key = key
    }
    
    func encode(_ urlRequest: URLRequest, with parameters: YFHttpParameters?) throws -> URLRequest {

        var urlRequest = try urlRequest.asURLRequest()
        //不对GET进行加密，使用默认处理
        if urlRequest.httpMethod == "GET" {
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        guard let parameters = parameters else { return urlRequest }
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("text/encrypted;aver=1", forHTTPHeaderField: "Content-Type")
            }
            //加密data
            urlRequest.httpBody = encryptData(data)
        }catch {
            //TODO throws error
        }
        
        return urlRequest
        
    }
    
    func encryptData(_ data: Data) -> Data {
        //TODO encryptData
        return data
    }
    
}




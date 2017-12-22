//
//  YFRequest.swift
//  httpclient
//
//  Created by 陈嘉维 on 2017/8/22.
//  Copyright © 2017年 yff. All rights reserved.
//

import Foundation
import Alamofire

typealias YFRequestParam = [String: Any]
typealias ResponseData = Any

protocol YFDataError: Error {}

enum YRequestResult<Value> {
    case success(Value)
    case failure(Error)
    
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }


    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
    
}



//MARK: HTTP Request

typealias YFHttpParameters = [String: Any]
typealias YFHttpHeader = [String: String]

//Request Method
enum YFHttpMethod {
    case get
    case head
    case post
    case put
    case delete
    case options
}

//Request Encoder
enum RequestEncryptType {
    case normal, trade
}

protocol YFRequestEncoder {
    func encode(_ urlRequest: URLRequest, with parameters: YFHttpParameters?) throws -> URLRequest
}



class YFRequest {
    var url: String
    var method: YFHttpMethod
    var param: YFHttpParameters?
    var encoder: YFRequestEncoder
    var headers: YFHttpHeader?
    
    //alamofire request
    var session: (() -> (SessionManager))?
    var request: DataRequest?
    
    required init(url: String,
                  method: YFHttpMethod,
                  param: YFHttpParameters? = nil,
                  encoder: YFRequestEncoder,
                  headers: YFHttpHeader?) {
        
        self.url = url
        self.method = method
        self.param = param
        self.encoder = encoder
        self.headers = headers
        
    }
    
    func header(_ header: YFHttpHeader) -> Self {
        self.headers = header
        return self
    }
    
    func encoder(_ encoder: YFRequestEncoder) -> Self {
        self.encoder = encoder
        return self
    }
    
}

class YFResponse<T> {
    var reqeust: YFRequest?
    var response: HTTPURLResponse?
    
    var data: Data?
    
    var result: YRequestResult<T>
    
    init(reqeust: YFRequest?,
         response: HTTPURLResponse?,
         data: Data?,
        result: YRequestResult<T>) {
        
        self.reqeust = reqeust
        self.response = response
        self.data = data
        self.result = result
        
    }
    
}

protocol YFResponseSerializer {
    
    associatedtype Value
    
    static func serializeResponse(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) -> YRequestResult<Value>
    
}

//MARK: Get response
extension YFRequest {
    
    func response<T>(_ serializer: T.Type, _ complete: ((YFResponse<T.Value>) -> ())? = nil) where T: YFResponseSerializer {
        
        let request = session?().request(url, method: method.alamoMethod(), parameters: param, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>)
        do {
            unwrapedRequest.task?.originalRequest = try encoder.encode(unwrapedRequest.request, with: param)
        } catch {
            //call back
            return
        }
        
        
        
        reqeust?.response(completionHandler: { (responseObj) in
            
            let result = serializer.serializeResponse(request: responseObj.request,
                                                      response: responseObj.response,
                                                      data: responseObj.data,
                                                      error: responseObj.error)
            
            
            let finalResponse = YFResponse<T.Value>(reqeust: self, response: responseObj.response, data: responseObj.data, result: result)
            complete?(finalResponse)
        })
        
    }
    
}








//
//  YFHttpClient.swift
//  httpclient
//
//  Created by 陈嘉维 on 2017/8/26.
//  Copyright © 2017年 yff. All rights reserved.
//

import Foundation
import Alamofire

protocol YFURLConvertible {
    func url() throws -> URL
}

//class Define
class YFRequestClient {
    
    static var defaultHeader: YFHttpHeader {
        return [String: String]()
    }
    
    var sessionManager: SessionManager = SessionManager.default
    
    
}



//MARK: - Request Method
//MARK : GET
extension YFRequestClient {
    
    func get(url: YFURLConvertible, param: YFHttpParameters? = nil)  {
        
    }
    
}


//MARK: - Request Method
//MARK : POST
extension YFRequestClient {
    
    func post(url: YFURLConvertible, param: YFHttpParameters? = nil)  {
        
    }
    
}

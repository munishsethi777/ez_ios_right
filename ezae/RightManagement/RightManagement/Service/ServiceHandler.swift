//
//  ServiceHandler.swift
//  right
//
//  Created by Baljeet Gaheer on 13/11/17.
//  Copyright © 2017 Baljeet Gaheer. All rights reserved.
//

import Foundation
enum HttpMethod : String {
    case  GET
    case  POST
    case  DELETE
    case  PUT
}
class ServiceHandler:NSObject {
    var request : URLRequest?
    var session : URLSession?
    static var action: String?
    static func instance() ->  ServiceHandler{
        return ServiceHandler()
    }
    
    static func instance(actionName: String) ->  ServiceHandler{
        self.action = actionName
        return ServiceHandler()
    }
    
    func makeAPICall(url: String,method: HttpMethod, completionHandler:@escaping (Data? ,HTTPURLResponse?  , NSError? ) -> Void) {
        request = URLRequest(url: URL(string: url)!)
        request?.httpMethod = method.rawValue
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        session = URLSession(configuration: configuration)
        session?.dataTask(with: request! as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completionHandler(data, response , error as NSError?)
                }else{
                    //show error message to user
                    let statusCode = response
                }
            }
            }.resume()
    }
    
}

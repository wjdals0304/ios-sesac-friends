//
//  QueueNetwork.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/04.
//

import Foundation
import Alamofire


struct QueueAPI {
    static let scheme = "http"
    static let host = "test.monocoding.com"
    static let port = 35484
    static let path = "/queue"
    
    func postOnqueue() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = QueueAPI.scheme
        components.host = QueueAPI.host
        components.port = QueueAPI.port
        components.path = QueueAPI.path + "/onqueue"
        
        return components
    }
}


class QueueNetwork {
    
    private let idtoken : String
    
    let queueApi = QueueAPI()
    var header: HTTPHeaders
    
    init(idtoken: String) {
        self.idtoken = idtoken
        self.header = ["idtoken" : self.idtoken]
    }
    
    
    func postOnqueue(region: Int, lat: Double, long:Double, completion: @escaping(Queue?,APIStatus?) -> Void ) {
        
        let param : Parameters = [
            "region" : region,
            "lat" : lat,
            "long" : long
        ]
        
        
        let url = queueApi.postOnqueue().url!
        self.header["Content-Type"] = "application/x-www-form-urlencoded"
        
        let dataRequest = AF.request(url
                                     ,method: .post
                                     ,parameters: param
                                     ,encoding: URLEncoding.httpBody
                                     ,headers: self.header
                                    )
        
        dataRequest.responseData { response in
            
            switch response.result {
                
            case .success :
                
                guard let statusCode = response.response?.statusCode else {
                    completion(nil,.failed)
                    return
                }
                
                guard let value = response.value else {
                    completion(nil,.noData)
                    return
                }
                
                print(statusCode)
                print(value)
                switch statusCode {
                    
                case 200 :
                    
                    let decoder = JSONDecoder()
                    
                    guard let queueData = try? decoder.decode(Queue.self, from: value)
                    else {
                        completion(nil,.invalidData)
                        return
                    }
                    completion(queueData,.success)
                
                case 401 :
                    completion(nil,.expiredToken)
                case 406 :
                    completion(nil,.unregisterdUser)
                case 500 :
                    completion(nil,.serverError)
                case 501:
                    completion(nil,.clientError)
                    
                default :
                    completion(nil,.failed)
                
                }
                
                
            case .failure(let error) :
                print(error)
                completion(nil,.failed)
                
            }
            
            
            
        }
        
    }
    
    
    
    
    
}



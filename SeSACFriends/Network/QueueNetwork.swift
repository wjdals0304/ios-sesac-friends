//
//  QueueNetwork.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/04.
//

import Foundation
import Alamofire
import SwiftyJSON

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
    
    func postQueue() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = QueueAPI.scheme
        components.host = QueueAPI.host
        components.port = QueueAPI.port
        components.path = QueueAPI.path
        
        return components
    }
    
    func postHobbyRequest() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = QueueAPI.scheme
        components.host = QueueAPI.host
        components.port = QueueAPI.port
        components.path = QueueAPI.path + "/hobbyrequest"
        
        return components
    }
    
    func postHobbyAccept() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = QueueAPI.scheme
        components.host = QueueAPI.host
        components.port = QueueAPI.port
        components.path = QueueAPI.path + "/hobbyaccept"
        
        return components
    }
    
    func deleteQueue() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = QueueAPI.scheme
        components.host = QueueAPI.host
        components.port = QueueAPI.port
        components.path = QueueAPI.path
        
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
    
    
    func postQueue(region : Int, long: Double , lat:Double ,hf:[String], completion: @escaping(APIStatus?) -> Void )  {
       
        
        let param: Parameters = [
            "type" : 2 ,
            "region": region,
            "lat": lat,
            "long" : long,
            "hf" : JSON(hf)
        ]
        let url = queueApi.postQueue().url!

        self.header["Content-Type"] = "application/x-www-form-urlencoded"

        let dateRequest = AF.request(url
                                     ,method: .post
                                     ,parameters: param
                                     ,encoding: URLEncoding.httpBody
                                     ,headers: self.header)
        
        dateRequest.responseData { response in
            
            switch response.result {
                
               case .success :
                
                guard let statusCode = response.response?.statusCode else {
                    completion(.failed)
                    return
                }

                switch statusCode {
                    
                 case 200 :
                    completion(.success)
                 case 201 :
                    completion(.reportThreeUser)
                 case 203:
                    completion(.penaltyone)
                 case 204:
                    completion(.penaltytwo)
                case 205:
                    completion(.penaltyThree)
                case 206:
                    completion(.noGender)
                case 401:
                    completion(.expiredToken)
                case 406:
                    completion(.unregisterdUser)
                case 500:
                    completion(.serverError)
                case 501:
                    completion(.clientError)
                    
                default :
                    completion(.failed)
                    
                }
                
               
              case .failure(let error) :
                print(error)
                completion(.failed)
                
            }
        }
        
    }
    
    func postHobbyRequest(otheruid:String,completion:@escaping(APIStatus?) -> Void) {
        
        let param : Parameters = [
            "otheruid" : otheruid
        ]
        
        
        let url = queueApi.postHobbyRequest().url!
        
        self.header["Content-Type"] = "application/x-www-form-urlencoded"

        let dateRequest = AF.request(url,method: .post,parameters: param, encoding: URLEncoding.httpBody, headers: self.header)
        
        dateRequest.responseData { response in
            
            switch response.result {
                
            case .success :
                guard let statusCode = response.response?.statusCode else {
                    completion(.failed)
                    return
                }
                
                switch statusCode {
                    
                case 200 :
                    completion(.success)
                case 201:
                    completion(.alreadyRequest)
                case 202:
                    completion(.suspendRequest)
                case 401:
                    completion(.expiredToken)
                case 406:
                    completion(.unregisterdUser)
                case 500:
                    completion(.serverError)
                case 501:
                    completion(.clientError)
                
                default:
                    completion(.failed)
                    
                }
                
                
            case .failure(let error) :
                print(error)
                completion(.failed)
                
                
            }
            
            
        }
        
    }
    
    func postHobbyAccept(otheruid: String ,completion:@escaping(APIStatus?) -> Void) {
        
        let param : Parameters = [
            "otheruid" : otheruid
        ]
    
        let url = queueApi.postHobbyAccept().url!
        
        self.header["Content-Type"] = "application/x-www-form-urlencoded"

        let dateRequest = AF.request(url,method: .post,parameters: param, encoding: URLEncoding.httpBody, headers: self.header)
        
        dateRequest.responseData { response in
            
            switch response.result {
                
            case .success :
                guard let statusCode = response.response?.statusCode else {
                    completion(.failed)
                    return
                }
                
                switch statusCode {
                    
                case 200 :
                    completion(.success)
                case 201:
                    completion(.alreadyRequest)
                case 202:
                    completion(.suspendRequest)
                case 203:
                    completion(.matchedState)
                case 401:
                    completion(.expiredToken)
                case 406:
                    completion(.unregisterdUser)
                case 500:
                    completion(.serverError)
                case 501:
                    completion(.clientError)
                
                default:
                    completion(.failed)
                    
                }
                
                
            case .failure(let error) :
                print(error)
                completion(.failed)
                
            }
        }
        
        
    }
    
    
    func deleteQueue(completion:@escaping(APIStatus?) -> Void) {
        
        let url = queueApi.deleteQueue().url!
        
        let dateRequest = AF.request(url,method: .delete,encoding: URLEncoding.httpBody,headers: self.header)
        
        
        dateRequest.responseData { response in
            
            switch response.result {
                
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    completion(.failed)
                    return
                }
                
                switch statusCode {
                    
                case 200:
                    completion(.success)
                case 201 :
                    completion(.matchedState)
                case 406 :
                    completion(.expiredToken)
                case 500:
                    completion(.serverError)
                    
                default:
                    completion(.failed)
                    
                }
            case .failure(let error) :
                print(error)
                completion(.failed)
            
            }
            
            
            
        }
        
        
        
    }
    
    
}



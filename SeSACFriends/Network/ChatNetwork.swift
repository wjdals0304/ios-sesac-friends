//
//  ChatNetwork.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/14.
//

import Foundation
import Alamofire


struct ChatAPI {
    static let scheme = "http"
    static let host = "test.monocoding.com"
    static let port = 35484
    static let path = "/chat/"

    func postChat(to: String) -> URLComponents {
        
        var components = URLComponents()
        components.scheme = ChatAPI.scheme
        components.host = ChatAPI.host
        components.port = ChatAPI.port
        components.path = ChatAPI.path + to
        
        return components
    }
    
    func getChat(from:String ,lastDate: String ) -> URLComponents {
        
        var components = URLComponents()
        components.scheme = ChatAPI.scheme
        components.host = ChatAPI.host
        components.port = ChatAPI.port
        components.path = ChatAPI.path + from
        
        components.queryItems = [
            URLQueryItem(name: "lastchatDate", value: lastDate)
        ]
        
        return components
    }

}


class ChatNetwork {
    
    private let idtoken : String

    
    let chatApi = ChatAPI()
    var header : HTTPHeaders
    
    init(idtoken: String){
        self.idtoken = idtoken
        self.header = ["idtoken" : self.idtoken]
    }
    
    func postChat(to:String ,chat: String ,completion: @escaping(Chat?,APIStatus?) -> Void){
        
        let url = chatApi.postChat(to: to).url!
        self.header["Content-Type"] = "application/x-www-form-urlencoded"
        
        let dataRequest = AF.request(url, method: .post ,encoding: URLEncoding.httpBody,headers: self.header)
        
        dataRequest.responseData { response in
            
            switch response.result {
                
            case .success :
                
                guard let statusCode = response.response?.statusCode else {
                    completion(nil, .failed)
                    return
                }
                
                guard let value = response.value else {
                    completion(nil, .noData)
                    return
                }
                
                switch statusCode {
                
                case 200 :
                    
                    let decoder = JSONDecoder()
                    guard let chatData = try? decoder.decode(Chat.self, from: value) else {
                        completion(nil,.invalidData)
                        return
                    }
                    
                    completion(chatData,.success)
                
                case 201 :
                    completion(nil,.noChat)
                case 401:
                    completion(nil,.expiredToken)
                case 406:
                    completion(nil,.unregisterdUser)
                case 500:
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
    
    
    func getChat(from: String, lastChatDate:String, completion:@escaping(ChatList?,APIStatus?) -> Void) {
        
        
        let url = chatApi.getChat(from: from, lastDate: lastChatDate).url!
        
        let dataRequest = AF.request(url, method: .get ,headers: self.header)
        
        dataRequest.responseData { response in
            
            switch response.result {
               
            case .success:
                
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
                    
                      guard let chatData = try? decoder.decode(ChatList.self, from: value)
                      else {
                        print("error")
                        completion(nil,.invalidData)
                          return
                      }
                     
                     completion(chatData,.success)
                    
                   case 401:
                    completion(nil,.expiredToken)
                   case 406:
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

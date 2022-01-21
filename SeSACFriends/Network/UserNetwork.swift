//
//  UserNetwork.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/20.
//

import Foundation
import Alamofire


enum APIStatus   {
    case success
    case noData
    case failed
    case invalidData
    case expiredToken
    case clientError
    case serverError
    case unregisterdUser
}

struct UserAPI {
    static let scheme = "http"
    static let host = "test.monocoding.com"
    static let port = 35484
    static let path = "/user"
    
    func getUser() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = UserAPI.scheme
        components.host = UserAPI.host
        components.port = UserAPI.port
        components.path = UserAPI.path
        
        return components
    }
}


class UserNetwork {
    
    private let idtoken : String
    
    let userApi = UserAPI()
    let header: HTTPHeaders

    
    init(idtoken: String) {
        self.idtoken = idtoken
        self.header =  [ "Content-Type": "application/json"
                          , "idtoken" : self.idtoken ]
    }
    
    
    
    /// 내 유저 정보가져오기
    /// - Parameter completion: user, apistatus 리턴
    func getUser(completion: @escaping(User?, APIStatus?) -> Void ){
        
        let url = userApi.getUser().url!
        
        
        let dataRequest = AF.request(url,
                                    method: .get,
                                    headers: self.header
                                    )
        
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
                
                
                switch statusCode  {
                    
                case 200 :
                    let decoder = JSONDecoder()
                    
                    guard let userData = try? decoder.decode(User.self, from: value)
                    else {
                        print("error")
                        completion(nil,.invalidData)
                        return
                    }
                    
                    completion(userData,.success)
                                    
                case 201 :
                    completion(nil,.unregisterdUser)
                case 401 :
                    completion(nil,.expiredToken)
                case 500 :
                    completion(nil,.serverError)
                case 501 :
                    completion(nil,.clientError)
                default:
                    completion(nil,.failed)
                }
                
            
            case .failure(let error):
                  print(error)
                  completion(nil,.failed)
            
           }
        }
    }
}

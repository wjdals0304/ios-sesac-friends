//
//  UserNetwork.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/20.
//

import Foundation
import Alamofire

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
    
    func postUser() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = UserAPI.scheme
        components.host = UserAPI.host
        components.port = UserAPI.port
        components.path = UserAPI.path
        
        return components
    }
    
    func withdrawUser() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = UserAPI.scheme
        components.host = UserAPI.host
        components.port = UserAPI.port
        components.path = UserAPI.path  + "/withdraw"
        
        return components
    }
    
    func updateMypage() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = UserAPI.scheme
        components.host = UserAPI.host
        components.port = UserAPI.port
        components.path = UserAPI.path + "/update/mypage"
        
        return components
        
    }
    
    func getShopMyInfo() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = UserAPI.scheme
        components.host = UserAPI.host
        components.port = UserAPI.port
        components.path = UserAPI.path + "/shop/myinfo"
        
        return components
    }
    
    func updateShop() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = UserAPI.scheme
        components.host = UserAPI.host
        components.port = UserAPI.port
        components.path = UserAPI.path + "/update/shop"

        return components

    }
    
    func postShopIos() -> URLComponents {
        
        var components = URLComponents()
        components.scheme = UserAPI.scheme
        components.host = UserAPI.host
        components.port = UserAPI.port
        components.path = UserAPI.path + "/shop/ios"
        
        return components
        
    }
}


class UserNetwork {
    
    private let idtoken: String
    
    let userApi = UserAPI()
    var header: HTTPHeaders
    
    init(idtoken: String) {
        self.idtoken = idtoken
        self.header =  ["idtoken": self.idtoken]
    }
    
    /// 내 유저 정보가져오기
    /// - Parameter completion: user, apistatus 리턴
    func getUser(completion: @escaping(User?, APIStatus?) -> Void ) {
        
        let url = userApi.getUser().url!
        
        let dataRequest = AF.request(url,
                                    method: .get,
                                    headers: self.header
                                    )
        
        dataRequest.responseData { response in
            
            switch response.result {
               
            case .success:

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
                    
                    print(value)
                    
                    guard let userData = try? decoder.decode(User.self, from: value)
                    else {
                        print("error")
                        completion(nil, .invalidData)
                        return
                    }
                    
                    completion(userData, .success)
                                    
                case 406 :
                    completion(nil, .unregisterdUser)
                case 401 :
                    completion(nil, .expiredToken)
                case 500 :
                    completion(nil, .serverError)
                case 501 :
                    completion(nil, .clientError)
                default:
                    completion(nil, .failed)
                }
                
            case .failure(let error):
                  print(error)
                  completion(nil, .failed)
            
           }
        }
    }
    
    /// 회원가입
    /// - Parameter completion: api 상태코드
    func postUser(completion: @escaping(APIStatus?) -> Void ) {

        guard let phoneNumber = UserManager.phoneNumber,
              let FCMtoken = UserManager.fcmtoken,
              let nick = UserManager.nickName,
              let birth = UserManager.birthday,
              let email = UserManager.email,
              let gender = UserManager.gender?.rawValue
        else {
            return
        }

        let param: Parameters = [
            "phoneNumber": phoneNumber,
            "FCMtoken": FCMtoken,
            "nick": nick,
            "birth": birth,
            "email": email,
            "gender": gender
        ]
        
        let url = userApi.postUser().url!
        self.header["Content-Type"] = "application/x-www-form-urlencoded"

        let dataRequest = AF.request(url, method: .post
                                     , parameters: param
                                     , encoding: URLEncoding.httpBody
                                     , headers: self.header
                                    )

        dataRequest.responseData { response in

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
                    completion(.registerdUser)
                case 202:
                    completion(.banNick)
                case 401:
                    completion(.expiredToken)
                case 500:
                    completion(.serverError)
                case 501:
                    completion(.clientError)
                default:
                    completion(.failed)
                }

            case .failure(let error):
                print(error)
                completion(.failed)

            }

        }
    }
    
    /// 회원가입탈퇴
    /// - Parameter completion: api 상태코드
    func withdrawUser(completion: @escaping(APIStatus?) -> Void) {
        
        let url = userApi.withdrawUser().url!
        
        let dataRequest = AF.request(url, method: .post, headers: self.header)
        
        dataRequest.responseData { response in
            
            switch response.result {
                
            case .success :
                
                guard let statusCode = response.response?.statusCode else {
                    completion(.failed)
                    return
                }
                                
                switch statusCode {
                    
                case 200 :
                    completion(.success)
                case 401:
                    completion(.expiredToken)
                case 406:
                    completion(.unregisterdUser)
                case 500:
                    completion(.serverError)
                    
                default:
                    completion(.failed)
                }
                
            case .failure(let error):
                print(error)
                completion(.failed)
                
            }
        }
    }
    
    /// 회원 업데이트
    /// - Parameters:
    ///   - searchable: 검색허용 여부
    ///   - ageMin: 나이 최소값
    ///   - ageMax: 나이 최고값
    ///   - gender: 성별
    ///   - hobby: 취미
    ///   - completion: API 상태
    func updateMypage(searchable: Int, ageMin: Int, ageMax : Int, gender: Int ,hobby: String , completion: @escaping(APIStatus?) -> Void) {
        
        let param: Parameters = [
            "searchable": searchable,
            "ageMin": ageMin ,
            "ageMax": ageMax,
            "gender": gender,
            "hobby": hobby
        ]
        
        let url = userApi.updateMypage().url!
        self.header["Content-Type"] = "application/x-www-form-urlencoded"

        let dataRequest = AF.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: self.header)

        dataRequest.responseData { response in
             
            switch response.result {
                
            case .success :
                
                guard let statusCode = response.response?.statusCode else {
                    completion(.failed)
                    return
                }
                
                switch statusCode {
                    
                case 200 :
                    completion(.success)
                case 401 :
                    completion(.expiredToken)
                case 406 :
                    completion(.unregisterdUser)
                case 500 :
                    completion(.serverError)
                case 501 :
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
    
        func getShopMyinfo(completion:@escaping(User?, APIStatus?) -> Void) {
        
        let url = userApi.getShopMyInfo().url!
        
        let dataRequest = AF.request(url, method: .get, headers: self.header)

        dataRequest.responseData { response in
            
            switch response.result {
               
            case .success:

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
                                        
                    guard let userData = try? decoder.decode(User.self, from: value)
                    else {
                        print("error")
                        completion(nil, .invalidData)
                        return
                    }
                    
                    completion(userData, .success)
                                    
                case 406 :
                    completion(nil, .unregisterdUser)
                case 401 :
                    completion(nil, .expiredToken)
                case 500 :
                    completion(nil, .serverError)
                case 501 :
                    completion(nil, .clientError)
                default:
                    completion(nil, .failed)
                }
                
            case .failure(let error):
                  print(error)
                  completion(nil, .failed)
            
           }
        }
    }
    
    func updateShop(sesac: Int, background: Int, completion:@escaping(APIStatus?) -> Void) {
        
        let url = userApi.updateShop().url!
        
        let param: Parameters = [
            "sesac": sesac ,
            "background": background
        ]
        
        let dataRequest = AF.request(url, method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: self.header)
        
        dataRequest.responseData { response in
            
            switch response.result {
                
            case .success:
                
                guard let statusCode = response.response?.statusCode else {
                    completion(.failed)
                    return
                }
                
                switch statusCode {
                    
                case 200:
                    completion(.success)
                case 201:
                    completion(.unownItem)
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
    
    func postShopIos(receipt: String, product: String, completion:@escaping(APIStatus?) -> Void ) {
        
        let url = userApi.postShopIos().url!
        
        let param: Parameters =  [
            "receipt": receipt,
            "product": product
        ]
        
        let dataRequest = AF.request(url, method: .post , parameters: param, encoding: URLEncoding.httpBody, headers: self.header)
        
        dataRequest.responseData { response in
            
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
                    completion(.failedReceipt)
                case 401 :
                    completion(.expiredToken)
                case 406 :
                    completion(.unregisterdUser)
                case 500 :
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
}

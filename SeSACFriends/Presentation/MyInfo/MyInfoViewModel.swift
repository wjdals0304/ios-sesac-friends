//
//  MyInfoViewModel.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/03.
//

import Foundation


class MyInfoViewModel {
    
    let imageArray = ["notice","faq","qna","setting_alarm","permit"]
    let textArray = ["공지사항","자주 묻는 질문","1:1 문의","알람 설정","이용 약관" ]
    
    
    ///  내 유저 정보가져오기
    /// - Parameters:
    ///   - idtoken: 파이어베이스 id 토큰
    ///   - completion:  user, apistatus  리턴
    func getUser(idtoken: String , completion: @escaping(User?,APIStatus?) -> Void ) {
     
        let userNetwork = UserNetwork(idtoken: idtoken)
        
        userNetwork.getUser { User, APIStatus in
            
            switch APIStatus {
                
            case .success:
                completion(User,.success)
                
            case .unregisterdUser:
                completion(nil,.unregisterdUser)
                
            case .noData:
                print(#function)
                print(".noData")
                completion(nil,.failed)
                
            case .invalidData:
                print(#function)
                print(".invalidData")
                completion(nil,.failed)
                
            case .expiredToken:
                print(#function)
                print(".expiredToken")
                completion(nil,.expiredToken)
    
                
            case .clientError :
                print(#function)
                print(".clientError")
                completion(nil,.failed)
            
            case .serverError :
                print(#function)
                print(".serverError")
                completion(nil,.failed)
                
            case  .none, .failed:
                print(#function)
                print(".failed")
                completion(nil,.failed)
                
            default :
                print(#function)
                print("default")
                completion(nil,.failed)

                
            }
                    
        }
        
        
        
    }
    
    
    
    func withDrawUser(completion: @escaping(APIStatus?) -> Void) {
        
        let idtoken = UserManager.idtoken!
        let userNetwork = UserNetwork(idtoken: idtoken)
        
        userNetwork.withdrawUser { APIStatus in
            
            switch APIStatus {
                
            case .success:
                completion(.success)
                
            case .expiredToken :
                completion(.expiredToken)
                
            case .unregisterdUser :
                completion(.unregisterdUser)
            
            case .serverError :
                completion(.failed)
            
            default :
                completion(.failed)
                
            }
            
        }
    }
    
    
    func updateMypage(searchable: Int, ageMin: Int, ageMax:Int, gender: Int, hobby:String,completion:@escaping(APIStatus?) -> Void) {
        
        let idtoken = UserManager.idtoken!
        let userNetwork = UserNetwork(idtoken: idtoken)
        
        userNetwork.updateMypage(searchable: searchable, ageMin: ageMin, ageMax: ageMax, gender: gender, hobby: hobby) { APIStatus in
            
            switch APIStatus {
                 
            case .success :
                completion(.success)
            case .expiredToken :
                completion(.expiredToken)
            case .unregisterdUser :
                print(#function)
                print("unregisterdUser")
                completion(.failed)
            case .serverError :
                print(#function)
                print("serverError")
                completion(.failed)
            default :
                completion(.failed)
        
                
            }
            
            
        }
        
        
    }
     
}

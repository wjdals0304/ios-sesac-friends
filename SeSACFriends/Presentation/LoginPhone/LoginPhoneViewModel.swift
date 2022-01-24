//
//  LoginPhoneViewModel.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/20.
//

import Foundation

//struct APIResult {
//    let data : Any?
//    let status : APIStatus
//
//    init(data: Any , status: APIStatus) {
//        self.data = data
//        self.status = status
//    }
//}

class LoginPhoneViewModel {
    
    
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
                completion(nil,.noData)
                
            case .invalidData:
                print(#function)
                print(".invalidData")
                completion(nil,.invalidData)
                
            case .expiredToken:
                print(#function)
                print(".expiredToken")
                completion(nil,.expiredToken)
    
                
            case .clientError :
                print(#function)
                print(".clientError")
                completion(nil,.clientError)
            
            case .serverError :
                print(#function)
                print(".serverError")
                completion(nil,.serverError)
                
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
    
}

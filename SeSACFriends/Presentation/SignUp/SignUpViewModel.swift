//
//  SignUpViewModel.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/24.
//

import Foundation


class SignUpViewModel {
    
    
    /// 회원가입
    /// - Parameters:
    ///   - idtoken: firebase id token
    ///   - completion: api 상태 리턴
    func postUser( completion: @escaping(APIStatus?) -> Void ) {
        
        let idtoken = UserManager.idtoken!
        let userNetwork = UserNetwork(idtoken: idtoken)
        
        userNetwork.postUser { APIStatus in
            
            switch APIStatus {
               
            case .success :
                completion(.success)
            
            case .registerdUser :
                completion(.registerdUser)
            
            case .banNick :
                completion(.banNick)
            
            case .expiredToken :
                completion(.expiredToken)
            
            case .serverError :
                print(#function)
                completion(.failed)
            case .clientError:
                print(#function)
                completion(.failed)

            default :
                completion(.failed)
                
            }
            
            
        }
        
        
        
    }
    
    
    
}

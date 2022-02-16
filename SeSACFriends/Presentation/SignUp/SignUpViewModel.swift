//
//  SignUpViewModel.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/24.
//

import Foundation


class SignUpViewModel {
    
    /// 이메일 검증
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testStr)
    }
    
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

//
//  AuthNetwork.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/16.
//

import Foundation
import FirebaseAuth


class AuthNetwork {
    
    
    static func sendVerificationCode(phoneNumber: String, completion:@escaping(String?,APIErrorMessage?) -> Void){
        
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil )
        {
            (varification , error ) in
            if error == nil {
                
                completion(varification!,.success)
                
            } else {
                
                if error != nil {
                    if let errorCode = AuthErrorCode(rawValue: error!._code){
                        
                        switch errorCode {
                        
                        case .tooManyRequests :
                            completion(nil,.tooManyRequests)
                            
                        default :
                            completion(nil,.failed)
                        }
                    }
                }
            }
            
        }
        
        
    }
    
    
    
    
}

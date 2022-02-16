//
//  LoginPhoneViewModel.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/20.
//

import Foundation

class LoginPhoneViewModel {
    

    func postVerificationCode(phoneNumber: String , completion:@escaping(String?,APIErrorMessage?) -> Void) {
        
        var phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
        
        let phoneNumberArr = Array(phoneNumber)
        
        if !self.isPhone(candidate: phoneNumber) && !(phoneNumberArr.count >= 10) {
            completion(nil,.wrongFormatPhoneNumber)
        }
        
        phoneNumber = "+82" + phoneNumber.substring(from: 1)
        
        AuthNetwork.sendVerificationCode(phoneNumber: phoneNumber) { varification, APIErrorMessage in
            
            switch APIErrorMessage {
                
            case .success :
                completion(varification, .success)
                
            case .tooManyRequests :
                completion(nil,.tooManyRequests)
            
            case .failed :
                completion(nil,.failed)
                
            default :
                completion(nil,.failed)
                
            }
            
            
        }
        
        
    }
    
    
    
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
    
    
    //MARK: 핸드폰 번호 유효성 검사
    func isPhone(candidate: String) -> Bool {
        
        // TODO: 유효성 검사
        let regex = "([0-9]{3})([0-9]{3,4})([0-9]{4})"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: candidate)

    }
    
    
    
    /// 코드체크
    func isCheckCode(str: String) -> Bool {
        let regex = "([0-9]{6})"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: str)
    }
    
    
    
    
}

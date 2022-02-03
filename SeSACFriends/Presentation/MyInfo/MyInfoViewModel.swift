//
//  MyInfoViewModel.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/03.
//

import Foundation


class MyInfoViewModel {
    
    
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

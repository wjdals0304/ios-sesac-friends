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
    
}

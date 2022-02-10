//
//  HobbyViewModel.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/10.
//

import Foundation


class HobbyViewModel {
    
    func postQueue(region: Int, lat: Double , long: Double , completion: @escaping(APIStatus?) -> Void ){
        
        let idtoken = UserManager.idtoken!
        let queueNetwork = QueueNetwork(idtoken: idtoken)
    
        var hf : [String]
        
        if UserManager.myHobbyArray.isEmpty {
            hf = ["Anything"]
        } else {
            hf = UserManager.myHobbyArray
        }

        queueNetwork.postQueue(region: region, long: long, lat: lat , hf: hf) { APIStatus in
         
            switch APIStatus {
                
            case .success :
                completion(.success)
                
            case .reportThreeUser :
                completion(.reportThreeUser)
            
            case .penaltyone :
                completion(.penaltyone)
            
            case .penaltytwo :
                completion(.penaltytwo)
            
            case .penaltyThree :
                completion(.penaltyThree)
            
            case .noGender :
                completion(.noGender)
             
            case .expiredToken :
                completion(.expiredToken)
                
            case .unregisterdUser :
                print("unregisteredUser")
                completion(.failed)
                
            case .clientError :
                print("clientError")
                completion(.failed)
                
            case .serverError :
                print("serverError")
                completion(.failed)
                
            case .failed :
                completion(.failed)
                
            default :
                completion(.failed)
            }
            
            
        }
        
    }
    
}

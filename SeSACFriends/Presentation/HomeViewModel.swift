//
//  HomeViewModel.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/04.
//

import Foundation


class HomeViewModel {
    
    
    func postOnqueue(region : Int, lat: Double, long: Double , completion: @escaping(Queue?, APIStatus?) -> Void) {
        
        let idtoken = UserManager.idtoken!
        let queueNetwork = QueueNetwork(idtoken: idtoken)
        
        
        queueNetwork.postOnqueue(region: region, lat: lat, long: long) { queue, APIStatus in
            
            switch APIStatus {
                
             case .success:
                completion(queue,.success)
                
            case .expiredToken :
                completion(nil,.expiredToken)
            
                    
            case .unregisterdUser: 
                print("unregisterdUser")
                completion(nil,.failed)

            case .clientError :
                print("clientError")
                completion(nil,.failed)
                
            case .serverError :
                print("serverError")
                completion(nil,.failed)
                
            case .failed :
                completion(nil,.failed)

            default :
                completion(nil,.failed)
            
            }
            
        }
        
        
        
        
    }
    
    
    
}

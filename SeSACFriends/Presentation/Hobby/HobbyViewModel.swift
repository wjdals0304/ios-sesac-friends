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
    
    func postHobbyRequest(otheruid : String, completion:@escaping(APIStatus?) -> Void) {
        
        
        let idtoken = UserManager.idtoken!
        let queueNetwork = QueueNetwork(idtoken: idtoken)
        
        queueNetwork.postHobbyRequest(otheruid: otheruid) { APIStatus in

            switch APIStatus {
            case .success :
                completion(.success)
            case .alreadyRequest :
                completion(.alreadyRequest)
            case .suspendRequest :
                completion(.suspendRequest)
            case .expiredToken :
                completion(.expiredToken)
            case .unregisterdUser :
                completion(.unregisterdUser)
                
            case .clientError :
                print("clientError")
                completion(.failed)
            case .serverError :
                print("serverError")
                completion(.failed)
            
            default :
                completion(.failed )
                
            
            }
        
        }
    }
        
    func postHobbyAccept(otheruid : String, completion:@escaping(APIStatus?) -> Void) {
            
            let idtoken = UserManager.idtoken!
            let queueNetwork = QueueNetwork(idtoken: idtoken)
            
            queueNetwork.postHobbyAccept(otheruid: otheruid) { APIStatus in

                switch APIStatus {
                case .success :
                    completion(.success)
                case .alreadyRequest :
                    completion(.alreadyRequest)
                case .suspendRequest :
                    completion(.suspendRequest)
                case .matchedState:
                    completion(.matchedState)
                case .expiredToken :
                    completion(.expiredToken)
                case .unregisterdUser :
                    completion(.unregisterdUser)
                case .clientError :
                    print("clientError")
                    completion(.failed)
                case .serverError :
                    print("serverError")
                    completion(.failed)
                
                default :
                    completion(.failed )
                    
                }
                
            }
        }
    
    func deleteQueue(completion:@escaping(APIStatus?) -> Void ){
        
        
        let idtoken = UserManager.idtoken!
        let queueNetwork = QueueNetwork(idtoken: idtoken)
        
        
        queueNetwork.deleteQueue { APIStatus in
            
            switch APIStatus {
        
            case .success:
                completion(.success)
            case .matchedState :
                completion(.matchedState)
            case .expiredToken:
                completion(.expiredToken)
            case .serverError:
                completion(.serverError)
            default:
                completion(.failed)
            }
            
        }
        
        
    }
        
    
    
}

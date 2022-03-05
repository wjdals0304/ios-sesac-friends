//
//  HobbyViewModel.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/10.
//

import Foundation

struct Location {
    
    var region : Int
    var lat : Double
    var long : Double
    
    init(region: Int, lat: Double , long: Double) {
        self.region = region
        self.lat = lat
        self.long = long
    }
}

class HobbyViewModel {

    var location = Location(region: 0, lat: 0.0, long: 0.0)
    var queueState = QueueState(dodged: 0, matched: 0, reviewed: 0, matchedNick: nil, matchedUid: nil)

    var hobbyArray: HobbyModel!
    var queueData: Queue!
    
    var aroundHobbyArray = [String]()
    var fromRecommendArray = [String]()
    var myHobbyArray = UserManager.myHobbyArray
    
    let sections: [String] = ["지금 주변에는", "내가 하고 싶은"]
        
    func changeSesacImage(sesac: Int ) -> String {
        
        if sesac == 0 {
            return "sesac_face_1"
        } else {
            return "sesac_face_1"
        }
    }
    
    func calculateRegion(lat: Double, long: Double) -> Int {
        
        let calLat = String(lat + 90).replacingOccurrences(of: ".", with: "").substring(to: 5)
        let calLong = String(long + 180).replacingOccurrences(of: ".", with: "").substring(to: 5)
        
        return Int(calLat + calLong)!

    }

    func postOnqueue(region: Int, lat: Double, long: Double, completion: @escaping(Queue?, APIStatus?) -> Void) {
        
        let idtoken = UserManager.idtoken!
        let queueNetwork = QueueNetwork(idtoken: idtoken)
        
        queueNetwork.postOnqueue(region: region, lat: lat, long: long) { result in
            
            switch result {
            
            case .success(let queue):
                // 지금 주변에는
                self.aroundHobbyArray += queue.fromQueueDB.flatMap {$0.hf}
                self.aroundHobbyArray = Array(Set(self.aroundHobbyArray))
                
                self.fromRecommendArray = queue.fromRecommend

                for i in self.aroundHobbyArray {
                    if self.fromRecommendArray.contains(i) { self.aroundHobbyArray.removeAll(where: { $0 == i } ) }
                }

                self.aroundHobbyArray = self.fromRecommendArray + self.aroundHobbyArray
               
                self.hobbyArray = HobbyModel(objectsArray: [ TableViewCellModel(category: "지금 주변에는", texts: []), TableViewCellModel(category: "내가 하고 싶은", texts: [])] )
                
                for hobby in self.aroundHobbyArray {
                    self.hobbyArray.objectsArray[HobbyCategory.arroundHobby.rawValue].texts.append(CollectionViewCellModel(name: hobby, subcategory: HobbyCategory.arroundHobby.rawValue))
                }
                
                for hobby in UserManager.myHobbyArray {
                    self.hobbyArray.objectsArray[HobbyCategory.myHobby.rawValue].texts.append(CollectionViewCellModel(name: hobby, subcategory: HobbyCategory.myHobby.rawValue))
                }
               
               completion(queue, .success)
            
            case .failure(let error):
                switch error {
                case .expiredToken:
                    completion(nil,.expiredToken)
                case .clientError:
                    completion(nil,.failed)
                case .serverError :
                    completion(nil,.serverError)
                case .failed:
                    completion(nil,.failed)
                default:
                    completion(nil,.failed)
                    
                }
        
        }
        
    }
    
    func postQueue(region: Int, lat: Double , long: Double , completion: @escaping(APIStatus?) -> Void ) {
        
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
    
    func postHobbyRequest(otheruid : String, completion: @escaping(APIStatus?) -> Void) {
        
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
        
    func postHobbyAccept(otheruid: String, completion: @escaping(APIStatus?) -> Void) {
            
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
    
    func deleteQueue(completion:@escaping(APIStatus?) -> Void) {
        
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
    
    func getMyQueueState(completion: @escaping(APIStatus?, MyqueueState?) -> Void) {
        
        let idtoken = UserManager.idtoken!
        let queueNetwork = QueueNetwork(idtoken: idtoken)
        
        queueNetwork.getMyQueueState { queueState, APIStatus in
            switch APIStatus {
            case .success:
                
                guard let queueState = queueState else {
                    return
                }

                self.queueState = queueState
                
             if queueState.matched == MatchedState.matched.rawValue {
                    completion(.success, MyqueueState.message)
             } else if queueState.matched == MatchedState.close.rawValue && UserManager.isMatch == true {
                 completion(.success, MyqueueState.antenna)
             } else {
                 completion(.success, MyqueueState.search)
             }
            
            case .stopSearch:
                completion(.stopSearch, nil)
            case .expiredToken :
                completion(.expiredToken, nil)
            case .unregisterdUser:
                completion(.unregisterdUser, nil)
            case .serverError :
                    completion(.serverError, nil)
            default :
                completion(.failed, nil)
            }
            
        }
    }
    
    func postDodge(otheruid: String, completion: @escaping(APIStatus?) -> Void) {
        
        let idtoken = UserManager.idtoken!
        let queueNetwork = QueueNetwork(idtoken: idtoken)
        
        queueNetwork.postDodge(otheruid: otheruid) { APIStatus in
            
            switch APIStatus {
                
            case .success:
                completion(.success)
            
            case .wrongUid:
                print("wrongUid")
                completion(.failed)
                
            case .expiredToken :
                completion(.expiredToken)

            case .unregisterdUser:
                completion(.failed)
                
            case .serverError :
                completion(.failed)
            
            case .clientError :
                print("clientError")
                completion(.failed)
            
            default :
                completion(.failed)
                
            }
        }
    }
  }
    
}

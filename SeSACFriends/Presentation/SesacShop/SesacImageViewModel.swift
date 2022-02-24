//
//  SesacImageViewModel.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/23.
//
import Foundation
import UIKit
import StoreKit

struct CustomProduct {
    
    let localizedTitle: String
    let localizedPrice : String
    let localizedDescription : String
    
    init(localizedTitle: String,localizedPrice: String, localizedDescription: String  ) {
        self.localizedTitle = localizedTitle
        self.localizedPrice = localizedPrice
        self.localizedDescription = localizedDescription
        
    }
    
}

final class SesacImageViewModel {
    
    var productIdentifiers : Set<String> = [
        "com.memolease.sesac1.sprout1",
        "com.memolease.sesac1.sprout2",
        "com.memolease.sesac1.sprout3",
        "com.memolease.sesac1.sprout4"
    ]
    
    var productsArray = Array<Any>()
    
    var sesacCollection = Array<Int>()
    var backgroundCollection = Array<Int>()
    var sesac = 0
    var background = 0
    
    
    func setSesacImage(index: Int ) -> String  {
        
        if index == 0 {
            return "sesac_face_1"
        } else if index == 1 {
            return "sesac_face_2"
        } else if index == 2 {
            return "sesac_face_3"
        } else if index == 3 {
            return "sesac_face_4"
        } else if index == 4 {
            return "sesac_face_5"
        } else {
            return ""
        }
    }
    func setBackground(index : Int) -> String {
        
        if index == 0 {
            return "sesac_background_1"
        } else if index == 1 {
            return "sesac_background_2"
        } else if index == 2 {
            return "sesac_background_3"
        } else if index == 3 {
            return "sesac_background_4"
        } else if index == 4 {
            return "sesac_background_5"
        } else if index == 5 {
            return "sesac_background_6"
        } else if index == 6 {
            return "sesac_background_7"
        } else if index == 7 {
            return "sesac_background_8"
        } else {
            return ""
        }
        
    }
    
    
    
    
    
    
    func getShopMyinfo(completion: @escaping(APIStatus?) -> Void ) {
        
        let idtoken = UserManager.idtoken
        guard let idtoken = idtoken else {
            return
        }

        let userNetwork = UserNetwork(idtoken: idtoken )
        
        userNetwork.getShopMyinfo { user, APIStatus in
            
            switch APIStatus {
                
            case .success:
                guard let user = user else {
                    return
                }
                self.sesac = user.sesac
                self.background = user.background
                self.sesacCollection = user.sesacCollection
                self.backgroundCollection = user.backgroundCollection
                
                
                completion(.success)
                
            case .unregisterdUser:
                completion(.unregisterdUser)
                
            case .noData:
                print(#function)
                print(".noData")
                completion(.noData)
                
            case .invalidData:
                print(#function)
                print(".invalidData")
                completion(.invalidData)
                
            case .expiredToken:
                print(#function)
                print(".expiredToken")
                completion(.expiredToken)
    
                
            case .clientError :
                print(#function)
                print(".clientError")
                completion(.clientError)
            
            case .serverError :
                print(#function)
                print(".serverError")
                completion(.serverError)
                
            case  .failed:
                print(#function)
                print(".failed")
                completion(.failed)
                
            default :
                print(#function)
                print("failed")
                completion(.failed)

            }
        }
 
        
    }
    
    
    
}

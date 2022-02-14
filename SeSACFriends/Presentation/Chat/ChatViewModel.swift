//
//  ChatViewModel.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/14.
//

import Foundation


class ChatViewModel  {
    

    func postChat(to:String, chat:String , completion: @escaping(Chat?, APIStatus?) -> Void) {
        
        let idtoken = UserManager.idtoken!
        let chatNetwork = ChatNetwork(idtoken: idtoken)
        
        chatNetwork.postChat(to: to, chat: chat) { chat, APIStatus in
            
            switch APIStatus {
                
            case .success :
                completion(chat ,.success)
            case .noChat :
                completion(nil,.noChat)
            case .expiredToken :
                completion(nil,.expiredToken)
            case .unregisterdUser:
                completion(nil,.failed)
            case .serverError:
                completion(nil,.failed)
            case .clientError:
                print("clientError")
                completion(nil,.failed)
            
            default :
                completion(nil,.failed)
                
            }
            
        }
        
        
    }
    
    
}

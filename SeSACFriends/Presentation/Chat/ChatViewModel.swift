//
//  ChatViewModel.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/14.
//

import Foundation


final class ChatViewModel  {
    
    
    func getChat(from: String, lastChatDate: String, completion:@escaping(ChatList?, APIStatus?) -> Void ) {
        
        let idtoken = UserManager.idtoken!
        let chatNetwork = ChatNetwork(idtoken: idtoken)
        
        chatNetwork.getChat(from: from, lastChatDate: lastChatDate) { chatList, APIStatus in
            
            switch APIStatus {
                
            case .success :
                completion(chatList,.success)
            case .expiredToken :
                completion(nil,.expiredToken)
            case .serverError:
                completion(nil,.failed)
            case .clientError:
                completion(nil,.failed)
            default :
                completion(nil,.failed)
            }
        
       }
    
    }
        
    

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

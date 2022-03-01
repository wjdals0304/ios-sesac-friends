//
//  Chat.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/14.
//

import Foundation


struct ChatList : Codable {
    let payload : [Chat]
}


struct Chat: Codable {
    
    let v: Int
    let id: String
    let chat: String
    let createdAt: String
    let from: String
    let to: String

    enum CodingKeys: String, CodingKey {
        
        case v = "__v"
        case id = "_id"
        case chat
        case createdAt,from,to
    }
    
}

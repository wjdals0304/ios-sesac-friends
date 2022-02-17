//
//  QueueState.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/17.
//

import Foundation


struct QueueState : Codable {
    
    let dodged : Int
    let matched : Int
    let reviewed: Int
    let matchedNick : String?
    let matchedUid : String?
    
}


enum dodgedState: Int {
    
    case matched = 0
    case close = 1
    
}

enum matchedState: Int {
    
    case matched = 0
    case close = 1
    
}

enum reviewedState : Int {
    
    case notReivew = 0
    case successReview = 1
}

enum MyqueueState : String {
   case message = "message"  // 채팅상태가 된 상태
   case antenna = "antenna" // 매칭 대기중인 상태
   case search = "search" // 기본 상태
}

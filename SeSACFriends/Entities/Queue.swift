//
//  Queue.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/04.
//

import Foundation



// MARK: - Queue
struct Queue: Codable {
    var fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

// MARK: - FromQueueDB
struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}

enum QueueType : String {
    
    case fromQueueDB
    case fromQueueDBRequested
    
}

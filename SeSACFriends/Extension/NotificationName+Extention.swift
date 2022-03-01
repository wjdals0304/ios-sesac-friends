//
//  NotificationName+Extention.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/03/01.
//

import Foundation


extension Notification.Name {
    
    static let changeSesacImage = Notification.Name(rawValue: "chagneSesacImage")
    
    static let changeBackgroundImage = Notification.Name(rawValue: "chagneBackgroundImage")
    
    static let changeFloatingButtonImage = Notification.Name(rawValue: "chagneFloatingButtonImage")
    
    static let refreshView = Notification.Name(rawValue: "refreshView")

    static let getMessage = Notification.Name(rawValue: "getMessage")
    
}

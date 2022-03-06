//
//  UserManager.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/24.
//

import Foundation

enum Gender: Int {
    case woman = 0
    case man = 1
    case none = -1
}

@propertyWrapper
struct UserDefault<T> {
    
    let key: String
    let defaultValue: T
    let userDefaults: UserDefaults
    
    var wrappedValue: T {
        get { self.userDefaults.object(forKey: self.key) as? T ?? self.defaultValue }
        set { self.userDefaults.set(newValue, forKey: self.key) }
    }
    
    init(key: String, defaultValue: T, userDefaults: UserDefaults = .standard ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

class UserManager {
    
    @UserDefault(key:"idtoken", defaultValue: nil)
    static var idtoken: String?
    
    @UserDefault(key:"uid", defaultValue: nil)
    static var uid: String?
    
    @UserDefault(key:"nickName", defaultValue: nil)
    static var nickName: String?
    
    @UserDefault(key:"phoneNumber", defaultValue: nil)
    static var phoneNumber: String?
    
    @UserDefault(key:"age", defaultValue: 0)
    static var age: Int

    @UserDefault(key:"email", defaultValue: nil)
    static var email: String?
    
    @UserDefault(key:"fcmtoken", defaultValue: nil)
    static var fcmtoken: String?
    
    @UserDefault(key:"birthday", defaultValue: nil)
    static var birthday: String?
    
    @UserDefault(key:"myHobby", defaultValue: [])
    static var myHobbyArray: [String]
    
    @UserDefault(key:"lastChatDate", defaultValue:nil)
    static var lastChatDate: String?
    
    @UserDefault(key:"isMatch", defaultValue: false)
    static var isMatch: Bool
    
    static var gender: Gender? {
        get { return Gender(rawValue: UserDefaults.standard.object(forKey: "gender") as! Int) ?? Gender.none }
        set { UserDefaults.standard.set(newValue?.rawValue, forKey: "gender") }
    }

    static func isFirst() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirst") == nil {
           defaults.set("No", forKey: "isFirst")
           return true
        } else {
            return false
        }
        
    }
}

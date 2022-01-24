//
//  UserManager.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/24.
//

import Foundation

enum Gender : Int {
    case woman = 0
    case man = 1
    case none = -1
}

class UserManager {
    
    
    static var idtoken : String? {
        get { return UserDefaults.standard.string(forKey: "idtoken")}
        set { UserDefaults.standard.set(newValue, forKey: "idtoken")}
    }
    
    
    static var nickName : String? {
        get { return UserDefaults.standard.string(forKey: "nickName") }
        set { UserDefaults.standard.set(newValue, forKey: "nickName")}
    }
    
    static var phoneNumber : String? {
        get { return UserDefaults.standard.string(forKey: "phoneNumber")}
        set { UserDefaults.standard.set(newValue, forKey: "phoneNumber")}
    }
    
    static var age : Int {
        get { return UserDefaults.standard.integer(forKey: "age")}
        set { UserDefaults.standard.set(newValue, forKey: "age")}
    }
    
    static var email : String? {
        get { return UserDefaults.standard.string(forKey: "email")}
        set { UserDefaults.standard.set(newValue,forKey: "email")}
    }
    
    
    static var gender : Gender? {
        get { return Gender(rawValue: UserDefaults.standard.object(forKey: "gender") as! Int) ?? Gender.none }
        set { UserDefaults.standard.set(newValue?.rawValue, forKey: "gender") }
    }
    
    static var fcmtoken : String? {
        get { return UserDefaults.standard.string(forKey: "fcmtoken")}
        set { UserDefaults.standard.set(newValue, forKey: "fcmtoken")}
    }
    
    
    static var birthday : String? {
        get { return UserDefaults.standard.string(forKey: "birthday")}
        set { UserDefaults.standard.set(newValue, forKey: "birthday")}
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

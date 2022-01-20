//
//  LoginPhoneViewModel.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/20.
//

import Foundation

struct APIResult {
    let data : Any?
    let status : APIStatus
    
    init(data: Any , status: APIStatus) {
        self.data = data
        self.status = status
    }
}

class LoginPhoneViewModel {
    
    func getUser(idtoken: String) -> APIResult {
        print("bbb")
     
        let userNetwork = UserNetwork(idtoken: idtoken)
        
        let apiResult = userNetwork.getUser()
        
    
    
}

//
//  APIStatus.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/24.
//

import Foundation


enum APIStatus   {
    
    case success
    case noData
    case failed
    case invalidData
    case expiredToken
    case clientError
    case serverError
    case unregisterdUser
    case registerdUser
    case banNick
    
}

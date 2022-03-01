//
//  APIErrorMessage.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/16.
//

import Foundation


enum APIErrorMessage: String ,Error {
    
    case tooManyRequests = "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요."
    case failed = "에러가 발생했습니다. 다시 시도해주세요."
    case wrongFormatPhoneNumber = "잘못된 전화번호 형식입니다."
    case success
    case hobbyRequestSuccess = "취미 함께 하기 요청을 보냈습니다."
    case suspendReqeust = "상대방이 취미 함께 하기를 그만두었습니다."
}

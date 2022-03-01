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
    case reportThreeUser // 신고하기 3번 이상 받은 유저
    case penaltyone // 취미 함께하기 약속 취소 패널티 1단계
    case penaltytwo // 패널티 2단계
    case penaltyThree // 패널티 3단계
    case noGender // 내 성별이 설정되지 않음
    case alreadyRequest // 상대가 이미 나에게 취미 함께하기 요청한 상태
    case suspendRequest // 상대가 취미 함께할 친구 찾기 중단한 상태
    case matchedState // 내가 이미 다른 사람과 취미 함께하기 매칭된 상태
    case noChat // 채팅전송불가
    case stopSearch // 친구 찾기 중단이 된 상태
    case wrongUid // 잘못된 otheruid
    case unownItem // 구매가 필요한 아이템이 있어요
    case failedReceipt // 영수증 검증실패
}

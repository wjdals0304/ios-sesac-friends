//
//  UIColor+extension.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/18.
//

import Foundation
import UIKit


enum Color {
    
    // 비활성화 버튼색
    case inactiveColor
    
    // bottom line
    case bottomlineColor
    
    // 기본 텍스트
    case defaultTextColor
    
    // 텍스트 흰색
    case whiteTextColor
    
    // 활성화 버튼색
    case activeColor
    
    // 회색 텍스트색
    case grayTextColor
    
    // 선택 버튼색
    case selectedButtonColor
    
    // top 라인 색
    case grayLineColor
    
    // red 색
    case redColor
    
    // 하늘색
    case blueColor
    
    // mychat cell
    case mychatColor

    // yourChat cell
    case yourChatColor
    
    
}

extension UIColor {
   static func getColor(_ name: Color) -> UIColor {
        
        switch name {
            
        case .inactiveColor :
            return UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1)
        
        case .bottomlineColor :
            return UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)
        
        case .defaultTextColor :
            return UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        
        case .whiteTextColor :
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            
        case .activeColor :
            return UIColor(red: 0.285, green: 0.863, blue: 0.574, alpha: 1)
            
        case .grayTextColor :
            return UIColor(red: 0.533, green: 0.533, blue: 0.533, alpha: 1)
            
        case .selectedButtonColor :
            return UIColor(red: 0.804, green: 0.958, blue: 0.881, alpha: 1)
            
        case .grayLineColor :
            return UIColor(red: 0.937, green: 0.937, blue: 0.937, alpha: 1)
            
        case .redColor :
            return UIColor(red: 0.913, green: 0.401, blue: 0.419, alpha: 1)
            
        case .blueColor :
            return UIColor(red: 0.384, green: 0.559, blue: 0.9, alpha: 1)
        case .mychatColor :
            return UIColor(red: 0.804, green: 0.958, blue: 0.881, alpha: 1)
        case .yourChatColor:
            return UIColor(red: 0.821, green: 0.821, blue: 0.821, alpha: 1)

            
        }
        
    }
}

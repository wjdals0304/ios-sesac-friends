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
    
    
    case defaultTextColor
    
    case whiteTextColor
    
}

extension UIColor {
    func getColor(_ name: Color) -> UIColor {
        
        switch name {
            
        case .inactiveColor :
            return UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1)
        case .bottomlineColor :
            return UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)
        case .defaultTextColor :
            return UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        case .whiteTextColor :
            return UIColor(red: 0.887, green: 0.887, blue: 0.887, alpha: 1)
        
            
        }
        
    }
}

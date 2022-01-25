//
//  UIFont+extension.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/21.
//

import Foundation
import UIKit


enum FontSize {
    
    case regular_12

    case regular_14
    
    case regular_16
    
    case regular_20
    
    case regular_24


    
}


extension UIFont {
    

    static func getRegularFont(_ size:FontSize) -> UIFont {


        switch size {

        case .regular_12 :
            return UIFont(name: "NotoSansKR-Regular", size: 12)!
        case .regular_14:
            return UIFont(name: "NotoSansKR-Regular", size: 14)!
        case .regular_16:
            return UIFont(name: "NotoSansKR-Regular", size: 16)!
        case .regular_20 :
            return UIFont(name: "NotoSansKR-Regular", size: 20)!
            
        case .regular_24 :
            return UIFont(name: "NotoSansKR-Regular", size: 24)!


        }



    }
    
    
    
}

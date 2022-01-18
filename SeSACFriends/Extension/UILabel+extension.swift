//
//  UILabel+extension.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/18.
//

import Foundation
import UIKit


extension UILabel {
    
    //MARK : 줄 간격
    var spasing:CGFloat {
            get {return 0}
            set {
                let textAlignment = self.textAlignment
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = newValue
                let attributedString = NSAttributedString(string: self.text ?? "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
                self.attributedText = attributedString
                self.textAlignment = textAlignment
            }
        }
    
}

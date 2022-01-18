//
//  UITextField+extension.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/18.
//

import UIKit


extension UITextField {
   
    func setUnderLine() {
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor().getColor(.bottomlineColor).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width - 10, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

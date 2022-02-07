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
    
    func asColor(targetString: String, color: UIColor) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
    
    
    func addTrailing(image: UIImage, with text: String) {
      let attachment = NSTextAttachment()
      attachment.image = image
      attachment.bounds = CGRect(x: 0, y: 0, width: 14, height: 13)
        

      let attachmentStr = NSAttributedString(attachment: attachment)

      let textString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.getRegularFont(.regular_14)])
      textString.append(attachmentStr)
     
      self.attributedText = textString
    }
        

}

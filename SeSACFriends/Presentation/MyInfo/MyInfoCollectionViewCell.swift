//
//  MyInfoCollectionViewCell.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/25.
//

import Foundation
import UIKit
import SnapKit

final class MyInfoCollectionViewCell : UICollectionViewCell {
    
    static let identifier = "MyInfoCollectionViewCell"
    
    let textLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_16)
        label.textColor = UIColor.getColor(.defaultTextColor)
        return label
    }()
    
    let imageView =  UIImageView()
    
    
    func setup(image: String , text: String ) {
        [
         textLabel,
         imageView
        ].forEach{ addSubview($0) }
        
        
        let border = CALayer()
        border.borderColor = UIColor.getColor(.grayLineColor).cgColor
        border.frame = CGRect(x: 0, y: 0, width: frame.width - 20 , height: 1)
        border.borderWidth = 1
        
        layer.addSublayer(border)
        
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(19)
            $0.top.equalToSuperview().offset(27)
        }
        
        textLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(14)
            $0.top.equalTo(imageView.snp.top)
        }
        
        imageView.image = UIImage(named: image)
        textLabel.text = text
        
    }
    
}

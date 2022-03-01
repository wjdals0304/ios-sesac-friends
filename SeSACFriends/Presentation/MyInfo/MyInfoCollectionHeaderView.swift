//
//  MyInfoCollectionHeaderVIew.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/25.
//

import Foundation
import UIKit


class MyInfoCollectionHeaderView : UICollectionReusableView {
    
    static let identifier = "MyInfoCollectionHeaderView"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.medium_16)
        return label
    }()
    
    let profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "profile_img")
        return image
    }()
  
    let tapImageView: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "Vector 49")
        return image
    }()
    
    
    func update(userData: User) {
        

        let border = CALayer()
        border.borderColor = UIColor.getColor(.grayLineColor).cgColor
        border.frame = CGRect(x: 0, y: 0, width: frame.width , height: 1)
        border.borderWidth = 1
        layer.addSublayer(border)
        
        [
         nameLabel,
         profileImageView,
         tapImageView
        ].forEach { addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(20)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(18)
            $0.centerY.equalTo(profileImageView.snp.centerY)
        }
        tapImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(22.5)
            $0.top.equalToSuperview().offset(40)
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.width.equalTo(15)
            $0.height.equalTo(18)
        }
    
        self.nameLabel.text = userData.nick
        
    }
}

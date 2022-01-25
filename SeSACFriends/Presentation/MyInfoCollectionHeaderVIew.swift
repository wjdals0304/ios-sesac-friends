//
//  MyInfoCollectionHeaderVIew.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/25.
//

import Foundation
import UIKit


class MyInfoCollectionHeaderVIew : UICollectionReusableView {
    
    static let identifier = "MyInfoCollectionHeaderVIew"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.medium_16)
        return label
    }()
    
  
    
    func update(){
        
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        
        self.nameLabel.text = "test"
        
        
        
    }
    
    
    
    
    
    
}

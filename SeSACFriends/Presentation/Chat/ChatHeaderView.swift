//
//  ChatHeaderView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/18.
//

import Foundation
import UIKit

class ChatHeaderView : UITableViewHeaderFooterView {
    
    
    static let identifier = "ChatHeaderView"
    
    
    lazy var descNickLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.grayTextColor)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.inactiveColor)
        return label
    }()
    
    
    
    func update() {
        
        [
          descNickLabel,
          descLabel
        ].forEach { addSubview($0) }
        
        
        descNickLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(self.snp.centerX)
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(descNickLabel.snp.bottom).offset(2)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        
        
    }
    
    
    
    
    
    
}

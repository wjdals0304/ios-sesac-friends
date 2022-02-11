//
//  SesacArroundView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/10.
//

import Foundation
import UIKit
import SnapKit

class SesacEmptyView : UIView {
    
    let sesacImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "sesac_black")
        return image
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_20)
        label.textColor = UIColor.getColor(.defaultTextColor)
        return label
    }()
    
    let desc2Label : UILabel = {
        let label = UILabel()
        label.text = "취미를 변경하거나 조금만 더 기다려 주세요!"
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.grayTextColor)
        return label
    }()
    
    let changeHobbyButton : UIButton = {
        let button = UIButton()
        button.setTitle("취미 변경하기", for: .normal)
        button.titleLabel?.tintColor = UIColor.getColor(.whiteTextColor)
        button.backgroundColor = UIColor.getColor(.activeColor)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(chagneHobbyButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bt_refresh"), for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(refreshButtonClicked), for: .touchUpInside)
        return button
    }()
    
    init(text: String){
        descLabel.text = text
        
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        
        setup()
        setupConstraint()
    }
 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setup() {
        [
            sesacImage,
            descLabel,
            desc2Label,
            changeHobbyButton,
            refreshButton
        ].forEach{ addSubview($0) }
    }
    
    func setupConstraint(){
        
        sesacImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(183)
            make.leading.equalToSuperview().offset(155)
            make.width.equalTo(self).multipliedBy(0.17)
            make.height.equalTo(50)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(56)
            make.top.equalTo(sesacImage.snp.bottom).offset(36)
            make.height.equalTo(32)
        }
        
        desc2Label.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(62)
            make.height.equalTo(22)
        }
        
        changeHobbyButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(50)
            make.width.equalTo(self).multipliedBy(0.76)
            make.height.equalTo(48)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.centerY.equalTo(changeHobbyButton.snp.centerY)
            make.leading.equalTo(changeHobbyButton.snp.trailing).offset(8)
            make.width.equalTo(self).multipliedBy(0.12)
            
        }
        
    }

    
    @objc func chagneHobbyButtonClicked() {
        
    }
    
    @objc func refreshButtonClicked() {
         
    }
    
    
}


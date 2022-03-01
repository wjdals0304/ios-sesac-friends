//
//  LoginPhoneView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/16.
//

import Foundation
import UIKit
import SnapKit


class LoginPhoneView : BaseUIView {
    
    
    let descLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_20)
        label.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.spasing = 1.08
        return label
    }()
    
    
    let  phoneNumberTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        return textField
    }()
    
    let verifySendButton : UIButton = {
        let button = UIButton()
        button.setTitle("인증 문자 받기", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        button.layer.cornerRadius = 8
        button.layer.backgroundColor = UIColor.getColor(.inactiveColor).cgColor
        return button
    }()
    
    
    override func setup() {
        
        [
            descLabel,
            phoneNumberTextField,
            verifySendButton
        ].forEach { addSubview($0) }
        
    }
    
    override func setupConstraint() {
        
        descLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(74)
            $0.top.equalToSuperview().offset(169)
        }
        
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(64)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(343)
            $0.height.equalTo(48)

        }
        
        verifySendButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(72)
            $0.width.equalTo(343)
            $0.height.equalTo(48)
        }
    }
    
}

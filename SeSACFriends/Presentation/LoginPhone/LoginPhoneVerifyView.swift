//
//  LoginPhoneVerifyView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/16.
//

import Foundation
import UIKit
import SnapKit

class LoginPhoneVerifyView: BaseUIView {
    
    
    let descLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_20)
        label.text = "인증번호가 문자로 전송되었어요"
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    let timeDescLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_16)
        label.text = "(최대 소모 60초)"
        label.textColor = UIColor.getColor(.grayTextColor)
        return label
    }()
    
    let textfieldView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
   
    let verificationCodeTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "인증번호 입력"
        textField.textContentType = .oneTimeCode
        return textField
    }()
    
    let timerLabel : UILabel = {
       let label = UILabel()
        label.text = "01:00"
        label.textColor = UIColor.getColor(.activeColor)
       return label
    }()
    
    let reSendButton : UIButton = {
        let button = UIButton()
        button.setTitle("재전송", for: .normal)
        button.layer.backgroundColor = UIColor.getColor(.activeColor).cgColor
        button.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let verifyStartButton : UIButton = {
       let button = UIButton()
        button.setTitle("인증하고 시작하기", for: .normal)
        button.layer.backgroundColor = UIColor.getColor(.inactiveColor).cgColor
        button.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    override func setup() {
        [
            descLabel,
            timeDescLabel,
            textfieldView,
            reSendButton,
            verifyStartButton
        ].forEach{ addSubview($0) }
        
        [
            verificationCodeTextField,
            timerLabel
        ].forEach { self.textfieldView.addSubview($0) }
    }
    
    override func setupConstraint() {
        
        descLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(168)
            $0.leading.equalToSuperview().offset(57.5)
            $0.width.equalTo(self.snp.width).multipliedBy(0.7)
            $0.height.equalTo(32)
        }
        
        timeDescLabel.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(132.5)
            $0.height.equalTo(26)
        }
        
        textfieldView.snp.makeConstraints {
            $0.top.equalTo(timeDescLabel.snp.bottom).offset(63)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(48)
        }

        verificationCodeTextField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        reSendButton.snp.makeConstraints {
            
            $0.leading.equalTo(textfieldView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(timerLabel.snp.centerY)
            $0.width.equalTo(72)
            $0.height.equalTo(40)

        }
        
        timerLabel.snp.makeConstraints {
            $0.trailing.equalTo(textfieldView.snp.trailing).inset(10)
            $0.bottom.equalTo(textfieldView.snp.bottom).inset(12)
        }
        
        verifyStartButton.snp.makeConstraints {
            $0.top.equalTo(verificationCodeTextField.snp.bottom).offset(72)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }
    
    
    
}

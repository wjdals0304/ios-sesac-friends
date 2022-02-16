//
//  SignUpEmailView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/16.
//

import Foundation
import UIKit
import SnapKit

final class SignUpEmailView : BaseUIView {
    
    let emailDescLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_20)
        label.text = "이메일을 입력해 주세요"
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.textAlignment = .center
        return label
    }()
    
    let emailSubDescLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_16)
        label.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        label.textColor = UIColor.getColor(.grayTextColor)
        return label
    }()
    
    let emailTextField : UITextField = {
       let textField = UITextField()
       textField.placeholder = "SeSAC@email.com"
       return textField
    }()
    
    let nextButton : UIButton = {
       let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.backgroundColor = UIColor.getColor(.inactiveColor)
        button.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    
    override func setup() {
        
        
        [
          emailDescLabel,
          emailSubDescLabel,
          emailTextField,
          nextButton
        ].forEach { self.addSubview($0) }
    }
    
    
    override func setupConstraint() {
        emailDescLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(168)
            $0.leading.equalToSuperview().offset(94)
        
        }
        
        emailSubDescLabel.snp.makeConstraints {
            $0.top.equalTo(emailDescLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(52)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailSubDescLabel.snp.bottom).offset(63)
            $0.leading.equalToSuperview().offset(16)
     
            $0.width.equalTo(UIScreen.main.bounds.width - 32)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(72)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(UIScreen.main.bounds.width - 32 )
            $0.height.equalTo(48)
        }
        
    }
    
    
    
    
    
}

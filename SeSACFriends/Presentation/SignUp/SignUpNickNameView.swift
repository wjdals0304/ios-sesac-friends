//
//  SignUpNickNameView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/16.
//

import Foundation
import UIKit
import SnapKit

final class SignUpNickNameView: BaseUIView {
    
    let nickDescLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 입력해 주세요"
        label.font = UIFont.getRegularFont(.regular_20)
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.textAlignment = .center
        return label
    }()
    
    
    let nickNameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "10자 이내로 입력"
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
            nickDescLabel,
            nickNameTextField,
            nextButton
        ].forEach{ addSubview($0) }
    }
    
    override func setupConstraint() {
        nickDescLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(94)
            $0.top.equalToSuperview().offset(185)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(nickDescLabel.snp.bottom).offset(80)
            $0.width.equalTo(UIScreen.main.bounds.size.width - 32)
        }
        
        nextButton.snp.makeConstraints {
            
            $0.leading.equalTo(nickNameTextField.snp.leading)
            $0.trailing.equalTo(nickNameTextField.snp.trailing)
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(72)
            $0.height.equalTo(48)
        }
    }
    
    
    
}

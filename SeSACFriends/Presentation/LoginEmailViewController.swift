//
//  LoginEmailViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/23.
//

import Foundation
import UIKit
import SnapKit

class LoginEmailViewController : UIViewController {
    
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
       textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
       return textField
    }()
    
    let nextButton : UIButton = {
       let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.backgroundColor = UIColor.getColor(.inactiveColor)
        button.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handelDoneBtn), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraint()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        self.emailTextField.setUnderLine()
    }
    
    func setup() {
        [
          emailDescLabel,
          emailSubDescLabel,
          emailTextField,
          nextButton
        ].forEach { self.view.addSubview($0) }
        
    }
    
    func setupConstraint() {
        
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
            $0.width.equalTo(view.frame.width - 40)
            
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(72)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(view.frame.width - 40 )
            $0.height.equalTo(48)
        }
        
        
    }
    
}


private extension LoginEmailViewController {
    
    @objc func textFieldDidChange() {
        
        if self.isValidEmail(testStr: emailTextField.text!) {
        
            nextButton.layer.backgroundColor = UIColor.getColor(.activeColor).cgColor
            
        } else {
            nextButton.layer.backgroundColor = UIColor.getColor(.inactiveColor).cgColor
            
        }
        
        
    }
    
    @objc func handelDoneBtn() {
        print("b")
    }
    
    
    /// 이메일 검증
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testStr)
    }

    
    
}

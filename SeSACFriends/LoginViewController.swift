//
//  LoginViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/17.
//

import Foundation
import UIKit
import SnapKit
import FirebaseAuth
import TextFieldEffects


class LoginViewController: UIViewController {
    
    private var verifyID: String?

    
    let descLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NotoSansKR-Regular", size: 20)
        label.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        label.textColor = UIColor().getColor(.defaultTextColor)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.spasing = 1.08
        return label
    }()
    
    
    let phoneNumberTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        return textField
    }()
    
    let verifySendButton : UIButton = {
        let button = UIButton()
        button.setTitle("인증 문자 받기", for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        button.setTitleColor(UIColor().getColor(.whiteTextColor), for: .normal)
        button.layer.cornerRadius = 8
        button.layer.backgroundColor = UIColor().getColor(.inactiveColor).cgColor
        button.addTarget(self, action: #selector(sendPhoneNumber), for: .touchUpInside)
        return button
    }()
        
//    let varificationCodeTextField : UITextField = {
//       let textField = UITextField()
//        textField.placeholder = "인증코드"
//        textField.layer.borderWidth = 1
//        return textField
//    }()
    
//    let doneButton : UIButton = {
//       let button = UIButton()
//        button.setTitle("확인", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.addTarget(self, action: #selector(handleDoneBtn), for: .touchUpInside)
//       return button
//    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        self.phoneNumberTextField.setUnderLine()

    }
    
    func setup() {
        
        [
            descLabel,
            phoneNumberTextField,
            verifySendButton
        ].forEach { self.view.addSubview($0) }
        
    }
    
    func setupConstraints() {
        
        descLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(74)
            $0.top.equalToSuperview().offset(169)
        }
        
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(64)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(343)
            $0.height.equalTo(48)

        }
        
        verifySendButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(72)
            $0.width.equalTo(343)
            $0.height.equalTo(48)
        }
        
        
        
    }

 
 
}

private extension LoginViewController {
    
    @objc func sendPhoneNumber() {
        

        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberTextField.text!, uiDelegate: nil ) { (varification , error ) in
            if error == nil {
                self.verifyID = varification
            } else {
                print("error")
                print(error.debugDescription)
            }
            
        }
        
    }
    
//    @objc func handleDoneBtn() {
//
//        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifyID!, verificationCode: varificationCodeTextField.text!)
//
//        Auth.auth().signIn(with: credential) {
//             ( success , error  ) in
//            if error == nil {
//                print("User signed in.. ")
//            } else {
//                print( error.debugDescription)
//            }
//        }
//
//
//    }
    
    
}


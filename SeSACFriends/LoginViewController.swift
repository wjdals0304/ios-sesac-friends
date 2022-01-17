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


class LoginViewController: UIViewController {
    
    private var verifyID: String?
    
    let phoneNumberTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "핸드폰 번호 입력"
        textField.layer.borderWidth = 1
        return textField
    }()
    
    let sendButton : UIButton = {
       let button = UIButton()
        button.setTitle("인증번호 전송", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(sendPhoneNumber), for: .touchUpInside)
        return button
    }()
    
    let varificationCodeTextField : UITextField = {
       let textField = UITextField()
        textField.placeholder = "인증코드"
        textField.layer.borderWidth = 1
        return textField
    }()
    
    let doneButton : UIButton = {
       let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleDoneBtn), for: .touchUpInside)
       return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupConstraints()
    }
    
    
    func setup() {
        
        [
            phoneNumberTextField,
            sendButton,
            varificationCodeTextField,
            doneButton
        ].forEach { self.view.addSubview($0) }
        
    }
    
    func setupConstraints() {
        
        phoneNumberTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.width.equalTo(150)
        }
        
        sendButton.snp.makeConstraints{
            $0.top.equalTo(phoneNumberTextField)
            $0.leading.equalTo(phoneNumberTextField.snp.trailing).offset(20)
            $0.width.equalTo(100)

        }
        
        varificationCodeTextField.snp.makeConstraints {
            
            $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(30)
            $0.width.equalTo(100)

        }
        
        
        doneButton.snp.makeConstraints{
            $0.top.equalTo(sendButton.snp.bottom).offset(20)
            $0.leading.equalTo(varificationCodeTextField.snp.trailing).offset(20)
            $0.width.equalTo(50)

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
    
    @objc func handleDoneBtn() {
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifyID!, verificationCode: varificationCodeTextField.text!)
        
        Auth.auth().signIn(with: credential) {
             ( success , error  ) in
            if error == nil {
                print("User signed in.. ")
            } else {
                print( error.debugDescription)
            }
        }
        
        
    }
    
    
}


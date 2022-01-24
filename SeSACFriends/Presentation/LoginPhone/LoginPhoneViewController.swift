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
import Toast_Swift

class LoginPhoneViewController: UIViewController {
    
    
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
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    let verifySendButton : UIButton = {
        let button = UIButton()
        button.setTitle("인증 문자 받기", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        button.layer.cornerRadius = 8
        button.layer.backgroundColor = UIColor.getColor(.inactiveColor).cgColor
        button.addTarget(self, action: #selector(sendPhoneNumber), for: .touchUpInside)
        return button
    }()

    
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



private extension LoginPhoneViewController {
    
    @objc func sendPhoneNumber() {
        
       var phoneNumber = phoneNumberTextField.text!.replacingOccurrences(of: "-", with: "")
       let phoneNumberArr = Array(phoneNumber)
        
       if !self.isPhone(candidate: phoneNumber) && !(phoneNumberArr.count >= 10) {
             self.view.makeToast("잘못된 전화번호 형식입니다.")
             return
        }
                
        phoneNumber = "+82" + phoneNumber.substring(from: 1)
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil )
        {
            (varification , error ) in
            if error == nil {
                
                let vc = LoginPhoneVerifyViewController(phoneNumber: phoneNumber, verifyID: varification!)

                self.navigationController?.pushViewController(vc, animated: true)

                
            } else {
                self.view.makeToast("에러가 발생했습니다. 다시 시도해주세요")
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
    
    @objc func textFieldDidChange() {
         
        let _str = phoneNumberTextField.text!.replacingOccurrences(of: "-", with: "")
        let phoneNumberArr = Array(_str)
            
        var modString = ""

            
        //MARK: 11자이상이고 핸드폰번호인 경우만 실행
        if self.isPhone(candidate: _str) && phoneNumberArr.count >= 10 {
            
            //MARK: 핸드폰 번호 유효성 검사
            if let regex = try? NSRegularExpression(pattern: "([0-9]{3})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive)
             {
                modString = regex.stringByReplacingMatches(in: _str, options: [], range: NSRange(_str.startIndex..., in: _str), withTemplate: "$1-$2-$3")
            }
            
            phoneNumberTextField.text = modString
            verifySendButton.layer.backgroundColor = UIColor.getColor(.activeColor).cgColor
            
        } else  {
            
            verifySendButton.layer.backgroundColor = UIColor.getColor(.inactiveColor).cgColor
            return

        }
    
    }
    
    //MARK: 핸드폰 번호 유효성 검사
    func isPhone(candidate: String) -> Bool {

        let regex = "([0-9]{3})([0-9]{3,4})([0-9]{4})"

        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: candidate)

    }



    
    
}


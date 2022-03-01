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


final class LoginPhoneViewController: BaseViewController {
    
    let loginPhoneView = LoginPhoneView()
    let loginPhonViewModel = LoginPhoneViewModel()
    
    override func loadView() {
        self.view = loginPhoneView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    
    override func viewDidLayoutSubviews() {
        loginPhoneView.phoneNumberTextField.setUnderLine()
    }
    
    override func addTarget() {
        
        loginPhoneView.phoneNumberTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        loginPhoneView.verifySendButton.addTarget(self, action: #selector(sendPhoneNumber), for: .touchUpInside)
    }
    
    
}


private extension LoginPhoneViewController {
    
    @objc func sendPhoneNumber() {
        
        guard let phoneNumber = loginPhoneView.phoneNumberTextField.text else {
            return
        }
        loginPhonViewModel.postVerificationCode(phoneNumber: phoneNumber) { varification, error in
            
            guard let varification = varification else {
                return
            }
            
            guard let error = error else {
                return
            }

            switch error {
                
            case .success :
                
                let vc = LoginPhoneVerifyViewController(phoneNumber: phoneNumber, verifyID: varification)
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .tooManyRequests :
                self.view.makeToast(APIErrorMessage.tooManyRequests.rawValue)
            case .failed :
                self.view.makeToast(APIErrorMessage.failed.rawValue)
            default :
                self.view.makeToast(APIErrorMessage.failed.rawValue)

            
            }
            
        }
    
    }
    
    @objc func textFieldDidChange() {
        
        guard let phoneNumber = loginPhoneView.phoneNumberTextField.text else {
            return
        }

        let _str = phoneNumber.replacingOccurrences(of: "-", with: "")
        let phoneNumberArr = Array(_str)

        var modString = ""


        // MARK: 11자이상이고 핸드폰번호인 경우만 실행
        if loginPhonViewModel.isPhone(candidate: _str) && phoneNumberArr.count >= 10 {

            // MARK: 핸드폰 번호 유효성 검사
            if let regex = try? NSRegularExpression(pattern: "([0-9]{3})([0-9]{3,4})([0-9]{4})", options: .caseInsensitive) {
                modString = regex.stringByReplacingMatches(in: _str, options: [], range: NSRange(_str.startIndex..., in: _str), withTemplate: "$1-$2-$3")
            }

            loginPhoneView.phoneNumberTextField.text = modString
            loginPhoneView.verifySendButton.layer.backgroundColor = UIColor.getColor(.activeColor).cgColor

        } else {

            loginPhoneView.verifySendButton.layer.backgroundColor = UIColor.getColor(.inactiveColor).cgColor
            return

        }

    }
}

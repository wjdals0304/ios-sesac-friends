//
//  LoginEmailViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/23.
//

import Foundation
import UIKit
import SnapKit
import Toast_Swift

final class SignUpEmailViewController : BaseViewController {
    
    let signUpEmailView = SignUpEmailView()
    let signUpViewModel = SignUpViewModel()
    
    override func loadView() {
        self.view = signUpEmailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraint()
        
    }
    
    override func viewDidLayoutSubviews() {
        signUpEmailView.emailTextField.setUnderLine()
    }
    
    override func addTarget() {
        signUpEmailView.emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        signUpEmailView.nextButton.addTarget(self, action: #selector(handelDoneBtn), for: .touchUpInside)
    }
    override func setupNavigationBar() {
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.leftBarButtonItem?.tintColor = .black

    }

    
}


private extension SignUpEmailViewController {
    
    @objc func closeButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange() {
        
        guard let emailText = signUpEmailView.emailTextField.text else {
            return
        }
        
        if signUpViewModel.isValidEmail(testStr: emailText ) {
        
            signUpEmailView.nextButton.layer.backgroundColor = UIColor.getColor(.activeColor).cgColor
            
        } else {
            signUpEmailView.nextButton.layer.backgroundColor = UIColor.getColor(.inactiveColor).cgColor
            
        }
        
        
    }
    
    @objc func handelDoneBtn() {
        
        
        guard let emailText = signUpEmailView.emailTextField.text else {
            
            self.view.makeToast("이메일 형식이 올바르지 않습니다.")
            return
        }
        
        if signUpViewModel.isValidEmail(testStr: emailText) {
            
            UserManager.email = emailText
            
            let vc = SignUpGenderViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            self.view.makeToast("이메일 형식이 올바르지 않습니다.")
        }
        
    }
    
}

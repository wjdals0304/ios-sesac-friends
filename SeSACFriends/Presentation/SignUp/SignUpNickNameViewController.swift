//
//  LoginNickNameViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/21.
//

import Foundation
import UIKit
import SnapKit
import Toast_Swift

final class SignUpNickNameViewController : BaseViewController {
    
    let signUpNickNameView = SignUpNickNameView()
    
    override func loadView() {
        self.view = signUpNickNameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidLayoutSubviews() {
        signUpNickNameView.nickNameTextField.setUnderLine()
    }
    
    override func setup() {
        view.backgroundColor = .systemBackground
        
    }
    
    override func addTarget() {
        
        signUpNickNameView.nickNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        signUpNickNameView.nextButton.addTarget(self, action: #selector(handleDoneBtn), for: .touchUpInside)
        
    }
    
    override func setupNavigationBar() {
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.leftBarButtonItem?.tintColor = .black
    }


}


private extension SignUpNickNameViewController {
    
    @objc func closeButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange() {
        
        guard let nickNameText = signUpNickNameView.nickNameTextField.text else {
            return
        }
        
        let nickName = nickNameText.replacingOccurrences(of: "-", with: "")
        let nickNameArr = Array(nickName)
        
        if nickNameArr.count >= 1 && nickNameArr.count < 10 {
            
            signUpNickNameView.nextButton.layer.backgroundColor = UIColor.getColor(.activeColor).cgColor
            
        } else {
            signUpNickNameView.nextButton.layer.backgroundColor = UIColor.getColor(.inactiveColor).cgColor
        }
    }
    
    
    @objc func handleDoneBtn() {
        
        guard let nickNameText = signUpNickNameView.nickNameTextField.text else {
            return
        }
        
        let nickNameArr = Array(nickNameText)
        
        
        if nickNameArr.count >= 1 && nickNameArr.count < 10 {
            UserManager.nickName = nickNameText
            
            let vc = SignUpBirthViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            self.view.makeToast("닉네임은 1자 이상 10자 이내로 부탁드려요.")
        }
        
        
    }
    
}

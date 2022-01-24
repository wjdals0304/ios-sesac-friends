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

class LoginNickNameViewController : UIViewController {
    
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
        button.addTarget(self, action: #selector(handleDoneBtn), for: .touchUpInside)
        
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraint()
    }
    
    
    override func viewDidLayoutSubviews() {
        self.nickNameTextField.setUnderLine()
    }
    
    func setup() {
        view.backgroundColor = .systemBackground
        [
            nickDescLabel,
            nickNameTextField,
            nextButton
        ].forEach{ self.view.addSubview($0) }
     
    }
    
    func setupConstraint() {
        
        
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
    
    @objc func textFieldDidChange() {
        
        let nickName = nickNameTextField.text!.replacingOccurrences(of: "-", with: "")
        let nickNameArr = Array(nickName)
        
        if nickNameArr.count >= 1 && nickNameArr.count < 10 {
            
            nextButton.layer.backgroundColor = UIColor.getColor(.activeColor).cgColor
            
        } else {
        
            nextButton.layer.backgroundColor = UIColor.getColor(.inactiveColor).cgColor
        }
    }
    
    
    @objc func handleDoneBtn() {
        
        let nickName = nickNameTextField.text!
        let nickNameArr = Array(nickName)
        
        
        if nickNameArr.count >= 1 && nickNameArr.count < 10 {
            UserManager.nickName = nickName
            
            let vc = LoginBirthViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            self.view.makeToast("닉네임은 1자 이상 10자 이내로 부탁드려요.")
        }
        
        
    }
    
    
}

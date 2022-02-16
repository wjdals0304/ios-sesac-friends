//
//  LoginGenderViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/23.
//

import Foundation
import UIKit
import FirebaseAuth
import Toast_Swift

final class SignUpGenderViewController : BaseViewController {
    
    let signUpViewModel = SignUpViewModel()
    
    let signUpGenderView = SignUpGenderView()
    
    var buttonIndex: Int?
    
    override func loadView() {
        self.view = signUpGenderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addTarget() {
        signUpGenderView.manUIButton.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)
        signUpGenderView.womanUIButton.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)

        signUpGenderView.nextButton.addTarget(self, action: #selector(handleDoneBtn), for: .touchUpInside)
        
    }
    
    override func setupNavigationBar() {
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.leftBarButtonItem?.tintColor = .black

    }
    
}

private extension SignUpGenderViewController {
    
    @objc func closeButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleDoneBtn() {
        
        if signUpGenderView.manUIButton.isSelected == true {
            UserManager.gender = Gender.man
            
        } else if signUpGenderView.womanUIButton.isSelected == true {
            UserManager.gender = Gender.woman
            
        } else {
            UserManager.gender = Gender.none
        }
                
        signUpViewModel.postUser { APIStatus in
            
            switch APIStatus {
                
            case .success :
                print("회원가입 성공!!")
                self.moveView(isNavigation: false, controller: TabBarController())

            case .registerdUser:
                self.moveView(isNavigation: false, controller: TabBarController())
                
            case .banNick :
                self.view.makeToast("다른 닉네임으로 변경해주세요", duration: 5.0 ,position: .top)
                self.moveView(isNavigation: true, controller: SignUpNickNameViewController())
            
            case .expiredToken:
                
                AuthNetwork.getIdToken { error in
                        switch error {
                        case .success :
                            self.handleDoneBtn()
                        case .failed :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        default :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        }
                    }
                
            default :
                self.view.makeToast("다른 닉네임으로 변경해주세요")

                
            }
            

        }
        
        
        
        
        
    }


    @objc func touchButton(_ sender: UIButton) {
      
        
        if buttonIndex != nil {
            
            if !sender.isSelected {
                for index in signUpGenderView.arrayButtons.indices {
                    signUpGenderView.arrayButtons[index].isSelected = false
                }
                sender.isSelected = true
                buttonIndex = signUpGenderView.arrayButtons.firstIndex(of: sender)
                
            } else {
                
                sender.isSelected = false
                buttonIndex = nil
                
            }
             
        } else {
            
            sender.isSelected = true
            buttonIndex = signUpGenderView.arrayButtons.firstIndex(of: sender)
        }
    

        if sender.isSelected {
            signUpGenderView.arrayButtons[buttonIndex!].setBackgroundColor(UIColor.getColor(.selectedButtonColor) ,for: .selected)
            
            signUpGenderView.nextButton.layer.backgroundColor = UIColor.getColor(.activeColor).cgColor
    
        } else {
            
            signUpGenderView.nextButton.layer.backgroundColor = UIColor.getColor(.inactiveColor).cgColor
            
        }
        
        
    }
    
}


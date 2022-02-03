//
//  PopUpWindowView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/30.
//

import Foundation
import UIKit
import FirebaseAuth

class PopUpWindowView : UIView {
    
    let popupView = UIView()
    
    let titleLabel : UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.getRegularFont(.medium_16)
       return label
    }()
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.getRegularFont(.regular_14)
        return label
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
        button.backgroundColor = UIColor.getColor(.grayLineColor)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let okButton : UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        button.backgroundColor = UIColor.getColor(.activeColor)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let buttonStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()

    
    init() {
        
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.3)

        addSubview(popupView)

        popupView.backgroundColor = .systemBackground
        popupView.layer.cornerRadius = 16
        
        [
          titleLabel,
          textLabel,
          cancelButton,
          okButton,
          buttonStackView
        ].forEach{ popupView.addSubview($0) }
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(okButton)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints() {
        
        popupView.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width - 32)
            $0.height.equalTo(156)
            $0.centerX.equalTo(self.snp.centerX)
            $0.centerY.equalTo(self.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(30)

        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(22)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(textLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
//            $0.width.equalTo(UIScreen.main.bounds.width - 32)
        }
        
        
    }
    
}


class PopUpWindow: UIViewController {
    
    private let popUpWindowView = PopUpWindowView()
    
    let myInfoViewModel = MyInfoViewModel()

    
    init(title: String , text: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        popUpWindowView.titleLabel.text = title
        popUpWindowView.textLabel.text = text
        
        popUpWindowView.cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        popUpWindowView.okButton.addTarget(self, action: #selector(okView), for: .touchUpInside)
        
        view = popUpWindowView
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func okView() {
        
        myInfoViewModel.withDrawUser { response in
            
            switch response {
                
               case .success :
                 print("온보딩화면으로")
                 let onboardingVC = OnboardingViewController()
                onboardingVC.modalPresentationStyle = .fullScreen
                self.present(onboardingVC, animated: true, completion: nil)
//                self.window?.rootViewController = onboardingVC
//                self.window?.makeKeyAndVisible()
//
                 
                
               case .unregisterdUser:
                 self.view.makeToast("이미 탈퇴가 된 상태입니다.")
                
               case .expiredToken :
                
                let currentUser = FirebaseAuth.Auth.auth().currentUser
                currentUser?.getIDToken(completion: { idtoken, error in
                guard let idtoken = idtoken else {
                        print(error!)
                        self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                        return
                 }
                
                 UserManager.idtoken = idtoken
                 self.okView()

                })
                
                
               case .serverError :
                  self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")

                
              default :
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")

                
            }
            
        }
        
    }
    
}

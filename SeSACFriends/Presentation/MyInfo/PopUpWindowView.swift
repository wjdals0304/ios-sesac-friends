//
//  PopUpWindowView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/30.
//

import Foundation
import UIKit
import FirebaseAuth

class PopUpWindowView: BaseUIView {
    
    let popupView = UIView()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.getRegularFont(.medium_16)
       return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.getRegularFont(.regular_14)
        label.numberOfLines = 0
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
        button.backgroundColor = UIColor.getColor(.grayLineColor)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let okButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        button.backgroundColor = UIColor.getColor(.activeColor)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let buttonStackView: UIStackView = {
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
        ].forEach { popupView.addSubview($0) }
        
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
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(textLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        
    }
    
}

class PopUpWindow: UIViewController {
    
    let popUpWindowView = PopUpWindowView()
    
    let myInfoViewModel = MyInfoViewModel()

    init(title: String, text: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        popUpWindowView.titleLabel.text = title
        popUpWindowView.textLabel.text = text
        
        popUpWindowView.cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        view = popUpWindowView
        
    }
    
    func updateTitle(title: String, text: String) {
        
        popUpWindowView.titleLabel.text = title
        popUpWindowView.textLabel.text = text

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

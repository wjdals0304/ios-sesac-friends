//
//  PopUpWindowView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/30.
//

import Foundation
import UIKit

class PopUpWindowView : UIView {
    
    let popupView = UIView()
    
    let titleLabel : UILabel = {
       let label = UILabel()
        label.textAlignment = .center
       return label
    }()
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
        return button
    }()
    
    let okButton : UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.setTitleColor(UIColor.getColor(.activeColor), for: .normal) 
        return button
    }()
    
    let buttonStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
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
            $0.width.equalTo(293)
            $0.centerX.equalTo(self.snp.centerX)
            $0.centerY.equalTo(self.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(textLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        
    }
    
}


class PopUpWindow: UIViewController {
    
    private let popUpWindowView = PopUpWindowView()
    
    
    init(title: String , text: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        popUpWindowView.titleLabel.text = title
        popUpWindowView.textLabel.text = text
        
        popUpWindowView.cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        view = popUpWindowView
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

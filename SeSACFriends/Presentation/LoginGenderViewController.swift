//
//  LoginGenderViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/23.
//

import Foundation
import UIKit


class LoginGenderViewController : UIViewController {
    
    var buttonIndex: Int?
    
    let genderDescLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_20)
        label.text = "성별을 선택해 주세요"
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.textAlignment = .center
        
       return label
    }()

    let genderSubDescLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_16)
        label.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        label.textColor = UIColor.getColor(.grayTextColor)
        
        return label
    }()
    
    let manUIButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "man"), for: .normal)
        button.setTitle("남자", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.getColor(.bottomlineColor).cgColor
        button.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)
        button.alignTextBelow(spacing: 10)

        return button
    }()
    

    let womanUIButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "woman"), for: .normal)
        button.setTitle("여자", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.getColor(.bottomlineColor).cgColor
        button.addTarget(self, action: #selector(touchButton(_:)), for: .touchUpInside)
        button.alignTextBelow(spacing: 10)
        return button
    }()
    
    var arrayButtons : [UIButton] = [UIButton]()
   

    
    var genderStackView = UIStackView ()
        
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
    
    func setup(){
        
        self.genderStackView = UIStackView(arrangedSubviews: [manUIButton,womanUIButton])
        self.genderStackView.spacing = 10
        self.genderStackView.axis = .horizontal
        self.genderStackView.distribution = .fillEqually
        
        
        self.arrayButtons = [self.manUIButton , self.womanUIButton]
        
        [
          genderDescLabel,
          genderSubDescLabel,
          genderStackView,
          nextButton
        ].forEach { self.view.addSubview($0)}
        
        
    }
    
    func setupConstraint() {
        
        genderDescLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(168)
            $0.leading.equalToSuperview().offset(103)
        }
        
        genderSubDescLabel.snp.makeConstraints {
            $0.top.equalTo(genderDescLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(44)
            
        }
                
        genderStackView.snp.makeConstraints {
            $0.top.equalTo(genderSubDescLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(self.view.frame.width - 40)
            $0.height.equalTo(120)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(genderStackView.snp.bottom).offset(32)
            $0.leading.equalTo(genderStackView.snp.leading)
            $0.trailing.equalTo(genderStackView.snp.trailing)
            $0.height.equalTo(48)
        }
    }
    
    
    
}

private extension LoginGenderViewController {
    
    @objc func handleDoneBtn() {
        
    }


    @objc func touchButton(_ sender: UIButton) {
      
        
        if buttonIndex != nil {
            
            if !sender.isSelected {
                for index in arrayButtons.indices {
                    arrayButtons[index].isSelected = false
                }
                sender.isSelected = true
                buttonIndex = arrayButtons.firstIndex(of: sender)
                
            } else {
                
                sender.isSelected = false
                buttonIndex = nil
                
            }
             
        } else {
            
            sender.isSelected = true
            buttonIndex = arrayButtons.firstIndex(of: sender)
                        
            
        }
        
        print( sender.isSelected , buttonIndex  )

        
        
    }
}


//
//  MyInfoDetailViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/26.
//

import Foundation
import UIKit
import SnapKit
import RangeSeekSlider

class MyInfoDetailViewController : UIViewController {
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    let contentView = UIView()
        
    let profileViewHeight : CGFloat = 252
    private lazy var profileView = ProfileView(profileImage: "default_profile_img", nick: "테스트", profileHeight: profileViewHeight)
    
    let textContentView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        return view
    }()
    
    let stackView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let genderView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        return view
    }()
    
    let genderLabel : UILabel = {
       let label = UILabel()
        label.text = "내 성별"
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.frame.size = label.intrinsicContentSize

        return label
    }()
    
    let manUIButton : UIButton = {
        let button = UIButton()
        button.setTitle("남자", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.getColor(.bottomlineColor).cgColor

        return button
    }()
    

    let womanUIButton : UIButton = {
        let button = UIButton()
        button.setTitle("여자", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.getColor(.bottomlineColor).cgColor
        return button
    }()
 
    let hobbyView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        return view
    }()
    
    let hobbyLabel : UILabel = {
        let label = UILabel()
        label.text = "자주 하는 취미"
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.frame.size = label.intrinsicContentSize
        return label
    }()
    
    let hobbyTextField : UITextField = {
       let textField = UITextField()
        textField.placeholder = "취미를 입력해 주세요"

       return textField
        
    }()
    
    let phoneNumberCheckView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        return view
    }()
    
    let phoneNumberCheckLabel: UILabel = {
       let label = UILabel()
        label.text = "내 번호 검색 허용"
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.frame.size = label.intrinsicContentSize
        return label
    }()
    
    let phoneNumberCheckSwitch: UISwitch = {
        let switchUI = UISwitch ()
        switchUI.isOn = false
        return switchUI
    }()
    
    let ageView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        return view
    }()
    
    let ageLabel : UILabel = {
        let label = UILabel()
        label.text = "상대방 연령대"
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.frame.size = label.intrinsicContentSize
        return label
    }()
    
    let ageSlider : RangeSeekSlider = {
        let slider = RangeSeekSlider()
      
        slider.minValue = 18
        slider.maxValue = 65
        slider.tintColor = UIColor.getColor(.inactiveColor)
        slider.colorBetweenHandles = UIColor.getColor(.activeColor)
        slider.handleColor = UIColor.getColor(.activeColor)
        slider.hideLabels = true
        slider.lineHeight = 4
        slider.handleDiameter = 20

        slider.addTarget(self, action: #selector(changeAgeValue(sender:)), for: .touchUpInside)
        return slider
    }()
    
    let ageValueLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.medium_14)
        label.textColor = UIColor.getColor(.activeColor)
        return label
    }()
    
    let withdrawView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        return view
    }()
    
    let withdrawButton : UIButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.addTarget(self, action: #selector(tapWithdrawButton), for: .touchUpInside)
        return button
    }()
    
    let popUpWindowView = PopUpWindow(title: "정말 탈퇴하시겠습니까?", text: "탈퇴하시면 새싹 프렌즈를 이용할 수 없어요ㅠ")
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setup()
        setupConstraint()
    }
    
    override func viewDidLayoutSubviews() {
        self.hobbyTextField.setUnderLine()
    }
    
    func setup() {
    
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        self.contentView.addSubview(profileView)
        self.contentView.addSubview(textContentView)
        
        [
            stackView
        ].forEach { textContentView.addSubview($0)}
        
        [
           genderLabel,
           manUIButton,
           womanUIButton
        ].forEach { genderView.addSubview($0)}
        
        [
           hobbyLabel,
           hobbyTextField
        ].forEach { hobbyView.addSubview($0)}
        
        [
         phoneNumberCheckLabel,
         phoneNumberCheckSwitch
        ].forEach { phoneNumberCheckView.addSubview($0)}
        
        [
          ageLabel,
          ageSlider,
          ageValueLabel
        ].forEach { ageView.addSubview($0)}
        
        [
          withdrawButton
        ].forEach { withdrawView.addSubview($0)}

        stackView.addArrangedSubview(genderView)
        stackView.addArrangedSubview(hobbyView)
        stackView.addArrangedSubview(phoneNumberCheckView)
        stackView.addArrangedSubview(ageView)
        stackView.addArrangedSubview(withdrawView)
    }
    
    func setupConstraint() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(self.scrollView.snp.width)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
            make.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo( view.frame.width - 32)
            $0.height.equalTo(profileViewHeight)
        }
        
        textContentView.snp.makeConstraints {
            $0.top.equalTo(self.profileView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.contentView.snp.bottom)
            $0.height.equalTo(500)
        }
        
        stackView.snp.makeConstraints {
//            $0.edges.equalTo(textContentView)
            
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
    
        genderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview()
        }
        
        manUIButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerY.equalTo(genderLabel.snp.centerY)
            $0.width.equalTo(56)
        }
        
        womanUIButton.snp.makeConstraints {
            $0.leading.equalTo(manUIButton.snp.trailing).offset(5)
            $0.top.equalToSuperview()
            $0.centerY.equalTo(genderLabel.snp.centerY)
            $0.width.equalTo(56)

            $0.trailing.equalToSuperview()
         }
        
        hobbyLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
        }
        
        hobbyTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerY.equalTo(hobbyLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
       
        phoneNumberCheckLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview()
        }
        
        phoneNumberCheckSwitch.snp.makeConstraints {
           $0.centerY.equalTo(phoneNumberCheckLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
    
        ageLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        ageValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(ageLabel.snp.centerY)
            $0.trailing.equalToSuperview()
            
        }
        ageSlider.snp.makeConstraints {
            $0.top.equalTo(ageLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            
        }
        withdrawButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview()
        }
        

    }
    
    
}


private extension MyInfoDetailViewController {
    

    
    @objc func changeAgeValue(sender: RangeSeekSlider) {
        ageValueLabel.text = "\(Int(sender.selectedMinValue)) - \(Int(sender.selectedMaxValue))"
    }
    
    
    @objc func tapWithdrawButton() {
        self.present(popUpWindowView ,animated: true, completion: nil)
    }
    
}

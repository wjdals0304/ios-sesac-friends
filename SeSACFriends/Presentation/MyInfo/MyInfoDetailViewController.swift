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
import FirebaseAuth

class MyInfoDetailViewController: UIViewController {
    
    private let userData : User!
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    let contentView = UIView()
        
    let profileViewHeight: CGFloat = 252
    private lazy var profileView = ProfileView(profileImage: "default_profile_img", userData: userData, profileHeight: profileViewHeight)

    let textContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let genderView: UIView = {
        let view = UIView()
        return view
    }()
    
    let genderLabel: UILabel = {
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
        button.layer.borderColor = UIColor.getColor(.bottomlineColor).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = UIColor.getColor(.whiteTextColor)
        button.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
        return button
    }()
    

    let womanUIButton: UIButton = {
        let button = UIButton()
        button.setTitle("여자", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.getColor(.bottomlineColor).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = UIColor.getColor(.whiteTextColor)
        button.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
        return button
    }()
 
    let hobbyView : UIView = {
        let view = UIView()
        return view
    }()
    
    let hobbyLabel: UILabel = {
        let label = UILabel()
        label.text = "자주 하는 취미"
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.frame.size = label.intrinsicContentSize
        return label
    }()
    
    let hobbyTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "취미를 입력해 주세요"

       return textField
        
    }()
    
    let phoneNumberCheckView: UIView = {
        let view = UIView()
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
        let switchUI = UISwitch()
        switchUI.isOn = false
        return switchUI
    }()
    
    let ageView: UIView = {
        let view = UIView()
        return view
    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "상대방 연령대"
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.frame.size = label.intrinsicContentSize
        return label
    }()
    
    lazy var ageSlider: RangeSeekSlider = {
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
    
    let ageValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.medium_14)
        label.textColor = UIColor.getColor(.activeColor)
        return label
    }()
    
    let withdrawView: UIView = {
        let view = UIView()
        return view
    }()
    
    let withdrawButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(UIColor.getColor(.defaultTextColor), for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        button.addTarget(self, action: #selector(tapWithdrawButton), for: .touchUpInside)
        return button
    }()
    
    let popUpWindowView = PopUpWindow(title: "정말 탈퇴하시겠습니까?", text: "탈퇴하시면 새싹 프렌즈를 이용할 수 없어요ㅠ")
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightButtonPressed))
        return button
    }()
    
    let myInfoViewModel = MyInfoViewModel()
    
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setup()
        setupConstraint()
        setupValue()
    }
    
    override func viewDidLayoutSubviews() {
        self.hobbyTextField.setUnderLine()
    }
    
    init(userData: User) {
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupValue() {
        
        if userData.gender == 0 {
            womanUIButton.backgroundColor = UIColor.getColor(.activeColor)
            womanUIButton.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
            
        } else if userData.gender == 1 {
            manUIButton.backgroundColor = UIColor.getColor(.activeColor)
            manUIButton.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        }
        
        ageValueLabel.text = "\(userData.ageMin) - \(userData.ageMax)"
        ageSlider.selectedMinValue = CGFloat(userData.ageMin)
        ageSlider.selectedMaxValue = CGFloat(userData.ageMax)
        
        if userData.searchable == 0 {
            phoneNumberCheckSwitch.isOn = false
        } else if userData.searchable == 1 {
            phoneNumberCheckSwitch.isOn = true
        }
        
        hobbyTextField.text = userData.hobby
        
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
        
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.navigationItem.title = "정보관리"
        
        navigationItem.leftBarButtonItem = backBarButton
        self.navigationController?.navigationBar.tintColor = .black
        
        self.popUpWindowView.popUpWindowView.okButton.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
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
            $0.top.equalTo(self.profileView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.contentView.snp.bottom)
            $0.height.equalTo(350)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
        
        genderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
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
            $0.top.equalToSuperview().offset(13)
        }
        
        hobbyTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerY.equalTo(hobbyLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
       
        phoneNumberCheckLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.leading.equalToSuperview()
        }
        
        phoneNumberCheckSwitch.snp.makeConstraints {
           $0.centerY.equalTo(phoneNumberCheckLabel.snp.centerY)
            $0.trailing.equalToSuperview()
        }
    
        ageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview()
        }
        ageValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(ageLabel.snp.centerY)
            $0.trailing.equalToSuperview()
            
        }
        ageSlider.snp.makeConstraints {
            $0.top.equalTo(ageLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(UIScreen.main.bounds.width - 46)
            $0.height.equalTo(25)
        }
        
        withdrawButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
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
    
    
    @objc func rightButtonPressed() {
        
        let searchable = phoneNumberCheckSwitch.isOn ? 1 : 0
        let ageMin = ageSlider.selectedMinValue
        let ageMax = ageSlider.selectedMaxValue
        let gender = userData.gender
        let hobby = hobbyTextField.text ?? ""
        
        myInfoViewModel.updateMypage(searchable: searchable , ageMin: Int(ageMin), ageMax: Int(ageMax), gender: gender, hobby: hobby ) { response in

            switch response {
                            
            case .success :
                
                self.navigationController?.popViewController(animated: true)
            
            case .expiredToken :
                
                AuthNetwork.getIdToken { error  in
                    
                    switch error {
                    case .success :
                        self.rightButtonPressed()
                    case .failed :
                        self.view.makeToast(APIErrorMessage.failed.rawValue)
                    default :
                        self.view.makeToast(APIErrorMessage.failed.rawValue)
                    }
                }
            
            default :
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                
            }
            
        }
    }
  
    @objc func closeButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func okButtonClicked() {
        
        myInfoViewModel.withDrawUser { response in
            
            switch response {
                
            case .success :
                 print("온보딩화면으로")
                 let onboardingVC = OnboardingViewController()
                onboardingVC.modalPresentationStyle = .fullScreen
                self.present(onboardingVC, animated: true, completion: nil)

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
                    self.okButtonClicked()
                })
                
            case .serverError :
                  self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
            default :
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                
            }
        }
    }
}

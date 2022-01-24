//
//  LoginVerifyViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/19.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginPhoneVerifyViewController : UIViewController {
    
    /// 멤버 변수
    private var phoneNumber : String?
    private var verifyID : String?

    /// 타이머 변수 선언
    var timer: Timer?
    
    /// 타이머에 사용할 번호값
    var timerNum: Int = 0
    
    let loginPhoneViewModel = LoginPhoneViewModel()
    
    let descLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_20)
        label.text = "인증번호가 문자로 전송되었어요"
        label.textColor = UIColor.getColor(.defaultTextColor)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    let timeDescLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.getRegularFont(.regular_16)
        label.text = "(최대 소모 60초)"
        label.textColor = UIColor.getColor(.grayTextColor)
        return label
    }()
    
    let textfieldView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
   
    let verificationCodeTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "인증번호 입력"
        textField.textContentType = .oneTimeCode
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    let timerLabel : UILabel = {
       let label = UILabel()
        label.text = "01:00"
        label.textColor = UIColor.getColor(.activeColor)
       return label
    }()
    
    let reSendButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("재전송", for: .normal)
        button.layer.backgroundColor = UIColor.getColor(.activeColor).cgColor
        button.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(sendPhoneNumber), for: .touchUpInside)
        
        return button
    }()
    
    let verifyStartButton : UIButton = {
       let button = UIButton()
        button.setTitle("인증하고 시작하기", for: .normal)
        button.layer.backgroundColor = UIColor.getColor(.inactiveColor).cgColor
        button.setTitleColor(UIColor.getColor(.whiteTextColor), for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleDoneBtn), for: .touchUpInside)
        return button
    }()
    
    lazy var backBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        setup()
        setupConstraint()
        startTimer()
    }
    
    override func viewDidLayoutSubviews() {
        self.verificationCodeTextField.setUnderLine()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(phoneNumber: String , verifyID : String ) {
        self.phoneNumber = phoneNumber
        self.verifyID = verifyID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        
    
        self.view.backgroundColor = .systemBackground
        self.view.makeToast("인증번호를 보냈습니다")
        

        [
            descLabel,
            timeDescLabel,
            textfieldView,
            reSendButton,
            verifyStartButton
        ].forEach{ self.view.addSubview($0)}
        
        [
            verificationCodeTextField,
            timerLabel
        ].forEach { self.textfieldView.addSubview($0) }
        
        navigationItem.leftBarButtonItem = backBarButton

    }
    
    func setupConstraint(){
        
        descLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(168)
            $0.leading.equalToSuperview().offset(57.5)
            $0.width.equalTo(view.snp.width).multipliedBy(0.7)
            $0.height.equalTo(32)
        }
        
        timeDescLabel.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(132.5)
            $0.height.equalTo(26)
        }
        
        textfieldView.snp.makeConstraints {
            $0.top.equalTo(timeDescLabel.snp.bottom).offset(63)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(48)
        }

        verificationCodeTextField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        reSendButton.snp.makeConstraints {
            
            $0.leading.equalTo(textfieldView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(timerLabel.snp.centerY)
            $0.width.equalTo(72)
            $0.height.equalTo(40)

        }
        
        timerLabel.snp.makeConstraints {
            $0.trailing.equalTo(textfieldView.snp.trailing).inset(10)
            $0.bottom.equalTo(textfieldView.snp.bottom).inset(12)
        }
        
        verifyStartButton.snp.makeConstraints {
            $0.top.equalTo(verificationCodeTextField.snp.bottom).offset(72)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }
    
    
}


private extension LoginPhoneVerifyViewController {
    
    @objc func closeButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func startTimer() {
        /// 기존에 타이머 동작중이면 중지 처리
        if timer != nil && timer!.isValid {
                timer!.invalidate()
        }
        
        /// 타이머 사용값 초기화
        timerNum = 60
        /// 1초 간격 타이머 시작
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    /// 타이머 동작 func
    @objc func timerCallback() {
        //60초 ~ 1초 까지 timeBtn의 타이틀 변경
        let minutes: Int = timerNum / 60 % 60
        let seconds: Int = timerNum % 60
        
        let minutesString = String(minutes).count == 1 ? "0" + String(minutes) : String(minutes)
        let secondsString = String(seconds).count == 1 ? "0" + String(seconds) : String(seconds)
        
        self.timerLabel.text = minutesString + ":" + secondsString
        
        
        //timerNum이 0이면(60초 경과) 타이머 종료
        if(timerNum == 0) {
            timer?.invalidate()
            timer = nil
            self.view.makeToast("전화번호 인증 실패")
        }
        
        //timerNum -1 감소시키기
        timerNum-=1
    }
    
    @objc func textFieldDidChange() {
        
        let code = verificationCodeTextField.text!.replacingOccurrences(of: "-", with: "")
        let codeArr = Array(code)
        
        if self.isCheckCode(str: code) && codeArr.count >= 6 {
            
            verifyStartButton.layer.backgroundColor = UIColor.getColor(.activeColor).cgColor
            
        } else {
            verifyStartButton.layer.backgroundColor = UIColor.getColor(.inactiveColor).cgColor
        }
        

    }
    
    /// 코드체크
    func isCheckCode(str: String) -> Bool {
        
        let regex = "([0-9]{6})"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: str)
    }
    
    
    /// 재전송 문자 보내기
    @objc func sendPhoneNumber() {
            
        let phoneNumber = self.phoneNumber!
       
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil )
        {
            (varification , error ) in
            if error == nil {
                self.verifyID = varification
                
                self.timerLabel.text = "01:00"
                self.verificationCodeTextField.text = ""
                self.startTimer()
                
            } else {
                print("error")
                print(error.debugDescription)
            }
            
        }
        
    }
    
    /// 코드번호 검증
    @objc func handleDoneBtn() {

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifyID!, verificationCode: verificationCodeTextField.text!)
        
        Auth.auth().languageCode = "kr"
  
        Auth.auth().signIn(with: credential) {
             ( success , error  ) in
            if error == nil {
                print("User signed in.. ")
                              
               /// Firebase 토큰 가져오기
              Auth.auth().currentUser?.getIDToken(completion: { idtoken, error in
                    guard let idtoken = idtoken else {
                        print(error!)
                        self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                        return
                   }
                  
                  print(idtoken)
                  
                  UserManager.phoneNumber = self.phoneNumber!
                  /// 유저 정보 가져오기
                   self.loginPhoneViewModel.getUser(idtoken: idtoken) { User, APIStatus in

                       switch APIStatus {
                           
                           
                        case .success:
                           print("200 로직 ")
                    
                           
                           
                        case .unregisterdUser:
                           print("닉네임 뷰로 이동")
                           let vc = LoginNickNameViewController()
                           self.navigationController?.pushViewController(vc, animated: true)
                           
                           
                           
                        case .expiredToken :
                           print("토큰 만료")
                           self.handleDoneBtn()
                           
                           
                        
                           
                           
                       case .noData , .invalidData ,.clientError,.serverError ,.failed,.none:
                           self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                       
                            
                    }
                        
                   }
                    
                    
                 
            })
                
            
                
            } else {
                print( error.debugDescription)
                self.view.makeToast("전화번호 인증 실패")

            }
        }


    }

    
    
    
}

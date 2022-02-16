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

final class LoginPhoneVerifyViewController : BaseViewController {
    
    /// 멤버 변수
    private var phoneNumber : String?
    private var verifyID : String?

    /// 타이머 변수 선언
    var timer: Timer?
    
    /// 타이머에 사용할 번호값
    var timerNum: Int = 0
    
    let loginPhoneViewModel = LoginPhoneViewModel()
    let loginPhoneVerifyView = LoginPhoneVerifyView()
    
    override func loadView() {
        self.view = loginPhoneVerifyView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
    }
    
    override func viewDidLayoutSubviews() {
        loginPhoneVerifyView.verificationCodeTextField.setUnderLine()
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
    

    override func setup(){
        self.view.backgroundColor = .systemBackground
        self.view.makeToast("인증번호를 보냈습니다")
    }
    
    override func addTarget() {
        
        loginPhoneVerifyView.verificationCodeTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        loginPhoneVerifyView.reSendButton.addTarget(self, action: #selector(sendPhoneNumber), for: .touchUpInside)
        loginPhoneVerifyView.verifyStartButton.addTarget(self, action: #selector(handleDoneBtn), for: .touchUpInside)
    }
    
    override func setupNavigationBar() {
        
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.leftBarButtonItem?.tintColor = .black

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
        
        loginPhoneVerifyView.timerLabel.text = minutesString + ":" + secondsString
        
        
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
        
        let code = loginPhoneVerifyView.verificationCodeTextField.text!.replacingOccurrences(of: "-", with: "")
        let codeArr = Array(code)
        
        if loginPhoneViewModel.isCheckCode(str: code) && codeArr.count >= 6 {
            
            loginPhoneVerifyView.verifyStartButton.layer.backgroundColor = UIColor.getColor(.activeColor).cgColor
            
        } else {
            loginPhoneVerifyView.verifyStartButton.layer.backgroundColor = UIColor.getColor(.inactiveColor).cgColor
        }
        

    }
    
    
    /// 재전송 문자 보내기
    @objc func sendPhoneNumber() {
            
        let phoneNumber = self.phoneNumber!
       
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil )
        {
            (varification , error ) in
            if error == nil {
                self.verifyID = varification
                
                self.loginPhoneVerifyView.timerLabel.text = "01:00"
                self.loginPhoneVerifyView.verificationCodeTextField.text = ""
                self.startTimer()
                
            } else {
                print("error")
                print(error.debugDescription)
            }
            
        }
        
    }
    
    /// 코드번호 검증
    @objc func handleDoneBtn() {

        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verifyID!, verificationCode: self.loginPhoneVerifyView.verificationCodeTextField.text!)
        
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
                  
                  
                  UserManager.idtoken = idtoken
                  UserManager.phoneNumber = self.phoneNumber!
                  
                  /// 유저 정보 가져오기
                   self.loginPhoneViewModel.getUser(idtoken: idtoken) { User, APIStatus in

                       switch APIStatus {
                           
                           
                        case .success:
                           print("200 로직 ")
                           
                           UserManager.uid = User?.uid
                           
                           let vc = TabBarController()
                           vc.modalPresentationStyle = .fullScreen
                           self.present(vc, animated: true, completion: nil)
                           
                           
                        case .unregisterdUser:
                           print("닉네임 뷰로 이동")
                           let vc = SignUpNickNameViewController()
                           self.navigationController?.pushViewController(vc, animated: true)
                           
                           
                        case .expiredToken :
                           print("토큰 만료")
                           self.handleDoneBtn()
                           
                           
                       case .noData , .invalidData ,.clientError,.serverError ,.failed,.none:
                           self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                           
                       default :
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

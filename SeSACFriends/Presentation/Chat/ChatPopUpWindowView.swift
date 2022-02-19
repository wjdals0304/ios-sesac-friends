//
//  ChatPopUpWindowView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/16.
//

import Foundation
import UIKit


class ChatPopUpWindowView : UIView {
    
    let popupView = UIView()
    
    let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let reportButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "siren"), for: .normal)
        button.setTitle("새싹 신고", for: .normal)
        button.alignTextBelow(spacing: 10)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        return button
    }()
    
    let promiseCancelButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "write"), for: .normal)
        button.setTitle("약속 취소", for: .normal)
        button.alignTextBelow(spacing: 10)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        return button
    }()
    
    let reviewButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "write"), for: .normal)
        button.setTitle("리뷰 등록", for: .normal)
        button.alignTextBelow(spacing: 10)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.getRegularFont(.regular_14)
        return button
    }()
    
    
    init() {
        
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        addSubview(popupView)
        popupView.backgroundColor = .systemBackground
        setup()
        setupConstraint()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        [
           stackView
        ].forEach{ popupView.addSubview($0) }
        
        stackView.addArrangedSubview(reportButton)
        stackView.addArrangedSubview(promiseCancelButton)
        stackView.addArrangedSubview(reviewButton)
        
    }

    func setupConstraint() {
    
        popupView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(72)
            make.top.leading.trailing.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        

    }

    
}


class ChatPopUpWindow: UIViewController {
    
    let chatPopUpWindowView = ChatPopUpWindowView()

    let popUpWindowView =  PopUpWindow(title: "약속을 취소하겠습니까?", text: "약속을 취소하시면 패널티가 부과됩니다.")
    
    let hobbyViewModel = HobbyViewModel()
    let chatViewModel = ChatViewModel()
    
    var otherUid: String
    
    init(otherUid : String ) {
        self.otherUid = otherUid

        super.init(nibName: nil, bundle: nil)

        modalTransitionStyle = .crossDissolve
     
        modalPresentationStyle = .overCurrentContext
        
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:)))
        self.view.addGestureRecognizer(tapGesture)

        [
            chatPopUpWindowView
        ].forEach{ view.addSubview($0) }
        
        chatPopUpWindowView.snp.makeConstraints { make in
            
            make.top.equalTo(view.safeAreaLayoutGuide).offset(44)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        chatPopUpWindowView.promiseCancelButton.addTarget(self, action: #selector(promiseCancelButtonClicked), for: .touchUpInside)
        popUpWindowView.popUpWindowView.okButton.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        checkQueueState()
    }
        
    @objc func tapView(_ sender: UITapGestureRecognizer){
    
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func promiseCancelButtonClicked() {
        self.present(popUpWindowView,animated: true,completion: nil)
    }
    
    @objc func okButtonClicked(){
        chatViewModel.postDodge(otheruid: self.otherUid) { APIStatus in
            
            switch APIStatus {
                
            case .success:
                self.view.makeToast("취미 함께하기 약속 취소 성공했습니다.")
                
            case .expiredToken:
                AuthNetwork.getIdToken { error in
                        switch error {
                        case .success :
                            self.okButtonClicked()
                        case .failed :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        default :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        }
                    }
                
            case .failed:
                self.view.makeToast(APIErrorMessage.failed.rawValue)
            
            default :
                self.view.makeToast(APIErrorMessage.failed.rawValue)
                
            }
            
            
        }
        
    }
    
    
    func checkQueueState() {
        
        hobbyViewModel.getMyQueueState { APIStatus, myqueueState in
            
            switch APIStatus {
                
            case .success :
                
                if (self.hobbyViewModel.queueState.dodged == dodgedState.close.rawValue)
                    || (self.hobbyViewModel.queueState.reviewed == reviewedState.successReview.rawValue ){
                    self.popUpWindowView.updateTitle(title: "약속을 종료하시겠습니까", text: "상대방이 약속을 취소했기 때문에 패널티가 부과되지 않습니다")
                }
                
             case .expiredToken:
                AuthNetwork.getIdToken { error in
                        switch error {
                        case .success :
                            self.checkQueueState()
                        case .failed :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        default :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        }
                    }
            default :
                self.view.makeToast(APIErrorMessage.failed.rawValue)
                
                
            }
            
            
            
            
        }
        
        
    }
    
    
    
    
    
    
}

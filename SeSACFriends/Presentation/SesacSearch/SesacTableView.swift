//
//  SesacTableViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/11.
//

import Foundation
import UIKit
import SnapKit
import MapKit
import Toast_Swift

class SesacTableView : UIView {
    
    lazy var tableview: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SesacTableViewCell.self, forCellReuseIdentifier: SesacTableViewCell.identifier)
        return tableView
    }()
    
    let hobbyViewModel = HobbyViewModel()
    
    var queueData: [FromQueueDB]
    var type : QueueType
    
    var otherUidData = [String]()
    
    init(queue: [FromQueueDB], type: QueueType ) {
        self.queueData = queue
        self.type = type
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
    
        setup()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        [
         tableview
        ].forEach { addSubview($0) }
        
    }
    
    func setupConstraint() {
        
        tableview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}

extension SesacTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.queueData.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SesacTableViewCell.identifier, for: indexPath) as? SesacTableViewCell else {
            return UITableViewCell()
        }

        let data = queueData[indexPath.row]
        cell.selectionStyle = .none
        cell.setupViews(with: data, type: self.type.rawValue)
        cell.requestButton.addTarget(self, action: #selector(requestButtonClicked(_:)), for: .touchUpInside)
        cell.requestButton.tag = indexPath.row
    
        return cell
    }

    @objc func requestButtonClicked(_ sender: UIButton ) {
        
        if self.type.rawValue ==  QueueType.fromQueueDB.rawValue {
            
            let popUpWindowView = PopUpWindow(title: "취미 같이 하기를 요청할게요!", text: "요청이 수락되면 30분 후에 리뷰를 남길 수 있어요")
            popUpWindowView.popUpWindowView.okButton.tag = sender.tag
            
            self.window?.rootViewController?.present(popUpWindowView, animated: true, completion: nil)
            popUpWindowView.popUpWindowView.okButton.addTarget(self, action: #selector(okButtonFromQueueDBClicked(_:)), for: .touchUpInside)

        } else {
            let popUpWindowView = PopUpWindow(title: "취미 같이 하기를 수락할까요?", text: "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요")
            popUpWindowView.popUpWindowView.okButton.tag = sender.tag
            self.window?.rootViewController?.present(popUpWindowView, animated: true, completion: nil)
            popUpWindowView.popUpWindowView.okButton.addTarget(self, action: #selector(okButtonFromQueueDBRequestedClicked(_:)), for: .touchUpInside)

        }
        
    }
    
    @objc func okButtonFromQueueDBClicked(_ sender: UIButton) {
                
        hobbyViewModel.postHobbyRequest(otheruid: self.queueData[sender.tag].uid ) { APIStatus in

            switch APIStatus {

            case .success :
                
                UserManager.isMatch = true

                self.window?.rootViewController?.presentationController?.presentedViewController.dismiss(animated: true, completion: nil)
                
                self.window?.rootViewController?.view.makeToast(APIErrorMessage.hobbyRequestSuccess.rawValue, duration: 2)
                
            case .alreadyRequest:
                
                print("201")
                self.window?.rootViewController?.view.makeToast(APIErrorMessage.hobbyRequestSuccess.rawValue)

            case .suspendRequest:
                self.window?.rootViewController?.view.makeToast(APIErrorMessage.suspendReqeust.rawValue)

            case .expiredToken:
                
                AuthNetwork.getIdToken { error in
                    switch error {
                    case .success :
                           self.okButtonFromQueueDBClicked(sender)
                    case .failed :
                            self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)
                    default :
                           self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)
                        }
                    }

            case .serverError, .clientError, .unregisterdUser, .failed:
                self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)

            default :
                self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)

            }
        }
    
    }
    
    @objc func okButtonFromQueueDBRequestedClicked(_ sender: UIButton) {
        
        hobbyViewModel.postHobbyAccept(otheruid: self.queueData[sender.tag].uid) { APIStatus in
            
            switch APIStatus {
                
            case .success :
                
                self.window?.rootViewController?.presentationController?.presentedViewController.dismiss(animated: true, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let vc = ChatViewController(queueData: self.queueData[sender.tag])
                                    
                   UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .alreadyRequest:
                
                self.window?.rootViewController?.view.makeToast("상대방이 이미 다른 사람과 취미를 함께하는 중입니다.")

            case .suspendRequest:
                self.window?.rootViewController?.view.makeToast("상대방이 취미 함께 하기를 그만두었습니다.")

            case .matchedState:
                self.window?.rootViewController?.view.makeToast("앗! 누군가가 나의 취미 함께 하기를 수락하였어요!")

            case .expiredToken:
                
                AuthNetwork.getIdToken { error in
                    switch error {
                    case .success :
                        self.okButtonFromQueueDBRequestedClicked(sender)
                    case .failed :
                        self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)
                    default :
                           self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)
                        }
                    }
            case .serverError,.clientError,.unregisterdUser,.failed:
                self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)
            default :
                self.window?.rootViewController?.view.makeToast(APIErrorMessage.failed.rawValue)
            }
            
        }
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

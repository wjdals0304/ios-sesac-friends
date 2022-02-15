//
//  ChattingViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/14.
//

import Foundation
import UIKit
import SnapKit
import FirebaseAuth


final class ChatViewController : UIViewController {
    
    let chatViewModel = ChatViewModel()
    
    lazy var backBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        return barButtonItem
    }()
    
    let contentView = UIView()

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatMyTableCell.self, forCellReuseIdentifier: ChatMyTableCell.identifier)
        tableView.register(ChatYourTableCell.self, forCellReuseIdentifier: ChatYourTableCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
//    let textView :  UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 8
//        view.layer.backgroundColor = UIColor.getColor(.grayLineColor).cgColor
//        return view
//    }()
    
    let textView : UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 8
        textView.layer.backgroundColor = UIColor.getColor(.grayLineColor).cgColor
        return textView
    }()
    
    let sendButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "text_inact"), for: .normal)
        button.addTarget(self, action: #selector(sendChat), for: .touchUpInside)
        return button
    }()
    
    let queueData : FromQueueDB
    var chatList : [Chat] = []
    
    init(queueData : FromQueueDB){
        self.queueData = queueData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        navigationItem.title = queueData.nick
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.titleView?.tintColor = .black
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
        
        setup()
        setupConstraint()
        requestChats()
    }
    

    
    
    func setup() {
        
        [
            contentView,
            tableView,
            textView,
            sendButton
        ].forEach{ self.view.addSubview($0) }
        
//        [
//            textView,
//            sendButton
//        ].forEach{ textView.addSubview($0) }
//
    }
    
    func setupConstraint(){
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(114)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(500)
//            make.bottom.equalTo(textView.snp.bottom)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.equalToSuperview().offset(16)
//            make.bottom.equalToSuperview().inset(50)
            make.width.equalTo(UIScreen.main.bounds.width - 32)
            make.height.equalTo(52)
        }
        
     
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(textView.snp.trailing).inset(14)
            make.centerY.equalTo(textView.snp.centerY)
        }
        
    }
    
    
    
}

private extension ChatViewController {
    
    @objc func closeButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func getMessage(notification: NSNotification) {
        
        let chat = notification.userInfo!["chat"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        let from = notification.userInfo!["from"] as! String
        let value = Chat(v: 0, id: "", chat: chat, createdAt: createdAt, from: from, to: "")
        
        chatList.append(value)
        tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: self.chatList.count - 1 , section: 0), at: .bottom, animated: false)
        
    }
    
    @objc func sendChat() {

        guard let chat = textView.text else {
            return
        }

        chatViewModel.postChat(to: self.queueData.uid , chat: chat) { chat, APIStatus in

            switch APIStatus {
             case .success :
                
                print("성공")
                UserManager.lastChatDate = chat?.createdAt
                
             case .noChat :
                print("실패")
             case .expiredToken :
                print("갱신 필요")
             case .failed :
                print("실패")
             default :
                print("실패")
            }
            
        }

    }
    
    
    func requestChats() {
        
        let lastChatDate = UserManager.lastChatDate ?? "2000-01-01T00:00:00.000Z"
        
        chatViewModel.getChat(from: self.queueData.uid, lastChatDate: lastChatDate) { chatList, APIStatus in
            
            switch APIStatus {
                
             case .success :
                self.chatList = chatList!.payload
                print(self.chatList )
                self.tableView.reloadData()
//                self.tableView.scrollToRow(at: IndexPath(row: self.chatList.count - 1 , section: 0), at: .bottom, animated: false)
//                SocketIOManager.shared.establishConnection()
                
            case .expiredToken :
                print("토큰")
                let currentUser = FirebaseAuth.Auth.auth().currentUser
                currentUser?.getIDToken(completion: { idtoken, error in
                guard let idtoken = idtoken else {
                        print(error!)
                        self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                        return
                 }
                 UserManager.idtoken = idtoken
                })
                self.requestChats()
                
            case .failed :
                print("실패")
            default :
                print("실패 ")
                
            }
            
        }
        
        
    }
    
    
    
}

extension ChatViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = chatList[indexPath.row]
    
        if data.from == UserManager.uid {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatMyTableCell.identifier, for: indexPath) as? ChatMyTableCell else {
                return UITableViewCell()
            }
            
            cell.configure()
            cell.chatLabel.text = data.chat
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatYourTableCell.identifier, for: indexPath) as? ChatYourTableCell else {
                return UITableViewCell()
            }
            
            cell.configure(text: data.chat)
            cell.chatTextView.text = data.chat
            cell.selectionStyle = .none

            return cell
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let chat = self.chatList[indexPath.row]
        let estimatedFrame = chat.chat.getEstimatedFrame(with: UIFont.getRegularFont(.regular_14))
        
        return estimatedFrame.height + 30
    }
}

extension ChatViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.textColor == UIColor.lightGray {
        textView.text = nil
        textView.textColor = UIColor.black
      }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text.isEmpty {
        textView.text = "메시지를 입력하세요."
        textView.textColor = UIColor.lightGray
      }
    }
    
    func textViewDidChange(_ textView: UITextView) {
            
            let size = CGSize(width: view.frame.width, height: .infinity)
            let estimatedSize = textView.sizeThatFits(size)
            
            textView.constraints.forEach { (constraint) in
            
              /// 180 이하일때는 더 이상 줄어들지 않게하기
                if estimatedSize.height <= 52 {
                
                }
                else {
                    if constraint.firstAttribute == .height {
                        constraint.constant = estimatedSize.height
                    }
                }
            }
        }
}

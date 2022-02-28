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
    let hobbyViewModel = HobbyViewModel()
    
    lazy var backBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        return barButtonItem
    }()
    
    lazy var moreBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreBarButtonClicked))
        return barButtonItem
    }()
    
    
    lazy var descNickLabel : UILabel = {
        let label = UILabel()
        label.text = "\(self.queueData.nick)님과 매칭되었습니다."
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.grayTextColor)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.text = "채팅을 통해 약속을 정해보세요 :)"
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.inactiveColor)
        return label
    }()

    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatMyTableCell.self, forCellReuseIdentifier: ChatMyTableCell.identifier)
        tableView.register(ChatYourTableCell.self, forCellReuseIdentifier: ChatYourTableCell.identifier)
        tableView.register(ChatHeaderView.self, forHeaderFooterViewReuseIdentifier: ChatHeaderView.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .systemBackground
        tableView.backgroundView = nil
        tableView.alwaysBounceVertical = false

        return tableView
    }()
    
    
    let textViewPlaceHolder = "메시지를 입력하세요."
    lazy var textView : UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 8
        textView.layer.backgroundColor = UIColor.getColor(.grayLineColor).cgColor
        textView.delegate = self
        textView.font = UIFont.getRegularFont(.regular_14)
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
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = moreBarButton
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.titleView?.tintColor = .black
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
        self.tabBarController?.tabBar.isHidden = true

        setup()
        setupConstraint()
        requestChats()
        SocketIOManager.shared.uid = UserManager.uid!
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOManager.shared.closeConnection()
    }

    func setup() {
        [
            tableView,
            textView,
            sendButton
        ].forEach{ self.view.addSubview($0) }
        
        
        // MARK: 키보드 디텍션
        NotificationCenter.default.addObserver(self, selector: #selector(adjustButtonView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustButtonView), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchHappen))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        
    }
    
    func setupConstraint(){
 
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(textView.snp.top)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(UIScreen.main.bounds.width - 32)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(50)
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
        self.tableView.scrollToRow(at: IndexPath(row: self.chatList.count - 1 , section: 0), at: .bottom, animated: true)
        
    }
    
    @objc func sendChat() {

        guard let chat = textView.text else {
            return
        }

        chatViewModel.postChat(to: self.queueData.uid , chat: chat) { chat, APIStatus in

            switch APIStatus {
             case .success :
                
                guard let chat = chat else {
                    return
                }
                UserManager.lastChatDate = chat.createdAt
                
                self.chatList.append(chat)
                
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: self.chatList.count - 1 , section: 0), at: .bottom, animated: true)
                self.textView.text = ""
                self.sendButton.setImage(UIImage(named: "text_inact"), for: .normal)

             case .noChat :
                
                self.view.makeToast(APIErrorMessage.failed.rawValue)
                
             case .expiredToken :
                AuthNetwork.getIdToken { error in
                        switch error {
                        case .success :
                            self.sendChat()
                        case .failed :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        default :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        }
                    }
            
            case .failed :
                self.view.makeToast(APIErrorMessage.failed.rawValue)
             default :
                self.view.makeToast(APIErrorMessage.failed.rawValue)
            }
        }
    }
    
    
    func requestChats() {
        
        //let lastChatDate = UserManager.lastChatDate ?? "2000-01-01T00:00:00.000Z"
        let lastChatDate = "2000-01-01T00:00:00.000Z"

        chatViewModel.getChat(from: self.queueData.uid, lastChatDate: lastChatDate) { chatList, APIStatus in

            switch APIStatus {
                
             case .success :
                self.chatList = chatList!.payload
                
                self.tableView.reloadData()
                if !self.chatList.isEmpty {
                    self.tableView.scrollToRow(at: IndexPath(row: self.chatList.count - 1 , section: 0), at: .bottom, animated: true)
                }
                SocketIOManager.shared.establishConnection()
                
            case .expiredToken :
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
                self.view.makeToast(APIErrorMessage.failed.rawValue)
            default :
                self.view.makeToast(APIErrorMessage.failed.rawValue)

            }
            
        }
        
        
    }
    
    @objc func moreBarButtonClicked() {
        
        let popUpWindow = ChatPopUpWindow(otherUid: self.queueData.uid)
        self.present(popUpWindow, animated: true, completion: nil)
        
    }
    
    func checkQueueState() {
        
        hobbyViewModel.getMyQueueState { APIStatus, myqueueState in
            
            switch APIStatus {
                
            case .success :
                if (self.hobbyViewModel.queueState.dodged == dodgedState.close.rawValue)
                    || (self.hobbyViewModel.queueState.reviewed == reviewedState.successReview.rawValue ){
                    self.view.makeToast("약속이 종료되어 채팅을 보낼 수 없습니다.")
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
    
    @objc private func adjustButtonView(noti: Notification) {
        
        guard let userInfo = noti.userInfo else { return }
        
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom + 40
            

            textView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(adjustmentHeight)
            }
                    
        } else {
            
            textView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(50)
              
            }
        }
    }
    
    @objc func touchHappen() {
        self.view.endEditing(true)
    }
    
    
}

extension ChatViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let data = chatList[indexPath.row]
        
        if data.from == UserManager.uid! {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatMyTableCell.identifier, for: indexPath) as? ChatMyTableCell else {
                return UITableViewCell()
            }

            cell.configure(text: data.chat, date: data.createdAt)
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatYourTableCell.identifier, for: indexPath) as? ChatYourTableCell else {
                return UITableViewCell()
            }
            
            cell.configure(text: data.chat , date : data.createdAt)
            cell.selectionStyle = .none

            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let chat = self.chatList[indexPath.row]
        let estimatedFrame = chat.chat.getEstimatedFrame(with: UIFont.getRegularFont(.regular_14))
        
        return estimatedFrame.height + 30
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChatHeaderView.identifier ) as? ChatHeaderView else {
            return UIView()
        }

        headerView.descNickLabel.text = "\(self.queueData.nick)님과 매칭되었습니다."
        headerView.descLabel.text =  "채팅을 통해 약속을 정해보세요 :)"
        headerView.update()
            
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }

}

extension ChatViewController : UITextViewDelegate {
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count >= 1 {
            sendButton.setImage(UIImage(named: "text_act"), for: .normal)
        } else {
            sendButton.setImage(UIImage(named: "text_inact"), for: .normal)
        }
        
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

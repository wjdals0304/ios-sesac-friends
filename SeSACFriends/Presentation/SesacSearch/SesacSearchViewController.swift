//
//  SesacSearchViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/10.
//

import Foundation
import UIKit
import SnapKit
import FirebaseAuth
import Toast_Swift

class SesacSearchViewController : UIViewController {
    
    let hobbyViewModel = HobbyViewModel()
    
    lazy var backBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        return barButtonItem
    }()
    
    lazy var rightButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(rightButtonClicked))
        return barButtonItem
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let items = ["주변 새싹", "받은 요청"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedClicked), for: .valueChanged)
        return segmentedControl
    }()
    
    let checkQueueTimer: Selector = #selector(checkQueueState)
    var checkTime = Timer()

    var sesacArroundView: UIView!
    var sesacRequestView: UIView!
    
    let contentView = UIView()
    
    init(location: Location) {
        self.hobbyViewModel.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "새싹 찾기"
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = rightButton

        navigationItem.titleView?.tintColor = .black
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        self.tabBarController?.tabBar.isHidden = true

        apiPostOnqueue()
        
        checkTime = Timer.scheduledTimer(timeInterval: 5, target: self, selector: checkQueueTimer, userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: NSNotification.Name("refreshView"), object: nil)
        
    }

    func setup() {
        [
         segmentedControl,
         contentView
        ].forEach { self.view.addSubview($0) }
        
        [
         sesacArroundView,
         sesacRequestView
        ].forEach { contentView.addSubview($0) }
        
    }
    
    func setupConstraint() {
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        sesacArroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sesacRequestView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

private extension SesacSearchViewController {
    
    @objc func closeButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshView() {
        print("refreshView")
        self.apiPostOnqueueForRefresh()
    }
    
    @objc func checkQueueState() {
        
        hobbyViewModel.getMyQueueState { APIStatus, myqueueState in

            switch APIStatus {
            
            case .success:
                
                switch myqueueState {
                
                case .message :
                    
                    self.view.makeToast( "\(String(describing: self.hobbyViewModel.queueState.matchedNick!))님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다.", duration: 1)
                    
                    self.checkTime.invalidate()
                    
                    NotificationCenter.default.post(name: .changeFloatingButtonImage, object: MyqueueState.message.rawValue)
                    
                case .antenna:
                    NotificationCenter.default.post(name: .changeFloatingButtonImage, object: MyqueueState.antenna.rawValue)
                    
                    self.checkTime.invalidate()

                case .search :
                    NotificationCenter.default.post(name: .changeFloatingButtonImage, object: MyqueueState.search.rawValue)
                    
                    self.checkTime.invalidate()

                default :
                    self.view.makeToast(APIErrorMessage.failed.rawValue)

                }
                
            case .stopSearch:
                self.view.makeToast("오랜 시간 동안 매칭 되지 않아 새싹 친구 찾기를 그만둡니다", duration: 1)
                self.checkTime.invalidate()
                
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

    @objc func rightButtonClicked() {
        
        hobbyViewModel.deleteQueue { APIStatus in
            
            switch APIStatus {
            
            case .success :
                print("성공")
                let vc = TabBarController()
                self.moveView(isNavigation: true, controller: vc)
                
                UserManager.isMatch = false
                
            case .matchedState:
                self.view.makeToast("누군가와 취미를 함께하기로 약속하셨어요!")
                print("채팅 화면으로 이동")
                
            case .expiredToken:
                
                let currentUser = FirebaseAuth.Auth.auth().currentUser
                currentUser?.getIDToken(completion: { idtoken, error in
                guard let idtoken = idtoken else {
                        print(error!)
                        self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                        return
                 }
                 UserManager.idtoken = idtoken
                })
                self.rightButtonClicked()
                
            case .serverError, .clientError :
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                
            default :
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
            }
            
        }
        
    }
    
    @objc func segmentedClicked(sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0 :
            self.contentView.bringSubviewToFront(sesacArroundView)
        case 1:
            self.contentView.bringSubviewToFront(sesacRequestView)
        default :
            break
        }
    }
    
    func apiPostOnqueue() {
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        hobbyViewModel.postOnqueue(region: hobbyViewModel.location.region, lat: hobbyViewModel.location.lat, long: hobbyViewModel.location.long) { queue, APIStatus in
            
            switch APIStatus {
                
            case .success :
                
                guard let queue = queue else {
                    self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                    return
                }
                
                self.hobbyViewModel.queueData = queue

                dispatchGroup.leave()

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
                self.apiPostOnqueue()
                dispatchGroup.leave()
                
            default :
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            
            if self.hobbyViewModel.queueData.fromQueueDB.isEmpty {
                self.sesacArroundView = SesacEmptyView(text: "아쉽게도 주변에 새싹이 없어요ㅠ", location: self.hobbyViewModel.location )
            } else {
                self.sesacArroundView = SesacTableView(queue: self.hobbyViewModel.queueData.fromQueueDB, type: QueueType.fromQueueDB)
            }
            
            if self.hobbyViewModel.queueData.fromQueueDBRequested.isEmpty {
                self.sesacRequestView = SesacEmptyView(text: "아직 받은 요청이 없어요ㅠ", location: self.hobbyViewModel.location)
            } else {
                self.sesacRequestView = SesacTableView(queue: self.hobbyViewModel.queueData.fromQueueDBRequested, type: QueueType.fromQueueDBRequested)
            }
            
            self.setup()
            self.setupConstraint()
            self.contentView.bringSubviewToFront(self.sesacArroundView)
        }
        
    }
    
    func apiPostOnqueueForRefresh() {
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        hobbyViewModel.postOnqueue(region: hobbyViewModel.location.region, lat: hobbyViewModel.location.lat, long: hobbyViewModel.location.long) { queue, APIStatus in
            
            switch APIStatus {
                
            case .success :
                
                guard let queue = queue else {
                    self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                    return
                }
                
                self.hobbyViewModel.queueData = queue

                dispatchGroup.leave()

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
                self.apiPostOnqueue()
                dispatchGroup.leave()
                
            default :
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            
            if self.hobbyViewModel.queueData.fromQueueDB.isEmpty {
                self.sesacArroundView = SesacEmptyView(text: "아쉽게도 주변에 새싹이 없어요ㅠ", location: self.hobbyViewModel.location)
            } else {
                self.sesacArroundView = SesacTableView(queue: self.hobbyViewModel.queueData.fromQueueDB, type: QueueType.fromQueueDB)
            }
            
            if self.hobbyViewModel.queueData.fromQueueDBRequested.isEmpty {
                self.sesacRequestView = SesacEmptyView(text: "아직 받은 요청이 없어요ㅠ", location: self.hobbyViewModel.location)
            } else {
                self.sesacRequestView = SesacTableView(queue: self.hobbyViewModel.queueData.fromQueueDBRequested, type: QueueType.fromQueueDBRequested)
            }
            
            self.setup()
            self.setupConstraint()
        }
        
    }

}

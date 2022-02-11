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

class SesacSearchViewController : UIViewController {
    
    private let region: Int
    private let lat: Double
    private let long : Double
    
    var queueData : Queue!
    
    let homeViewModel = HomeViewModel()
    
    lazy var backBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        return barButtonItem
    }()
    
    lazy var rightButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(rightButtonClicked))
        return barButtonItem
    }()
    
    let segmentedControl : UISegmentedControl = {
        let items = ["주변 새싹", "받은 요청"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedClicked), for: .valueChanged)
        return segmentedControl
    }()
    
    var sesacArroundView : UIView!
    let sesacRequestView = SesacRequestView()
    
    let subContentView = UIView()
    
    init(region: Int, lat: Double ,long: Double) {
        self.region = region
        self.lat = lat
        self.long = long
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        // TODO: 큐가 빈경우 로직 추가
        apiPostOnqueue()

    }

    func setup() {
        [
         segmentedControl,
         subContentView
        ].forEach{ self.view.addSubview($0) }
        
        
        [
         sesacArroundView,
         sesacRequestView
        ].forEach{ subContentView.addSubview($0) }
    }
    
    func setupConstraint() {
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        subContentView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        sesacArroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//            make.bottom.equalTo(self.scrollView.frameLayoutGuide)
        }
        
        sesacRequestView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(self.view)
//        }
//
//        mainContentView.snp.makeConstraints { make in
//            make.width.equalTo(self.scrollView.snp.width)
//            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
//            make.edges.equalTo(scrollView.contentLayoutGuide)
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

private extension SesacSearchViewController {
    
    @objc func closeButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }

    @objc func rightButtonClicked() {
        
    }
    
    @objc func segmentedClicked(sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0 :

            self.subContentView.bringSubviewToFront(sesacArroundView)
            
            break
        case 1:

            self.subContentView.bringSubviewToFront(sesacRequestView)
            break
        default :
            break
        }
    }
    
    
    func apiPostOnqueue() {
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        homeViewModel.postOnqueue(region: region, lat: lat, long: long) { queue, APIStatus in
            
            switch APIStatus {
                
            case .success :
                
                guard let queue = queue else {
                    self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
                    return
                }
                
                self.queueData = queue
                self.queueData.fromQueueDB.append(FromQueueDB(uid: "", nick: "text", lat: 0, long: 0, reputation: [], hf: [], reviews: [], gender: 0, type: 0, sesac: 0, background: 0))
                
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
            
            
            if self.queueData.fromQueueDB.isEmpty {
                self.sesacArroundView = SesacEmptyView(text: "아쉽게도 주변에 새싹이 없어요ㅠ")
            } else {
                self.sesacArroundView = SesacTableView(queue: self.queueData.fromQueueDB)
            }
            
            self.setup()
            self.setupConstraint()
            self.subContentView.bringSubviewToFront(self.sesacArroundView)
        }
        
    }
    
}

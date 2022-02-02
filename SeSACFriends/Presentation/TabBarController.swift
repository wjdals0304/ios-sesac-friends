//
//  TabBarController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/17.
//

import Foundation
import UIKit


class TabBarController: UITabBarController {
    
    private var userData : User?
    
    
    init(userData: User){
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        
        
        homeViewController.tabBarItem = UITabBarItem(title:"홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        
        
        //test 용
        self.userData = User(id: "11111", v: 0, uid: "", phoneNumber: "", email: "", fcMtoken: "", nick: "테스트입니다.", birth: "", gender: 0, hobby: "자전거타기", comment: [], reputation: [1,0,0,0,0,1], sesac: 0, sesacCollection: [], background: 0, backgroundCollection: [], purchaseToken: [], transactionID: [], reviewedBefore: [], reportedNum: 0, reportedUser: [], dodgepenalty: 0, dodgeNum: 0, ageMin: 23, ageMax: 30, searchable: 1, createdAt: "")
        
        
        let myInfoViewController = UINavigationController(rootViewController: MyInfoViewController(user: userData!))
        
        
        myInfoViewController.tabBarItem = UITabBarItem(title:"내정보", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person"))
        
        
        viewControllers = [  homeViewController, myInfoViewController ]
    }
    
    
    
}

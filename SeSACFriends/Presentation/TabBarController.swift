//
//  TabBarController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/17.
//

import Foundation
import UIKit


class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let myInfoViewController = UINavigationController(rootViewController: MyInfoViewController())
        
        
        myInfoViewController.tabBarItem = UITabBarItem(title:"내정보", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person"))
        
        
        viewControllers = [ myInfoViewController ]
        
        
    }
    
    
    
}

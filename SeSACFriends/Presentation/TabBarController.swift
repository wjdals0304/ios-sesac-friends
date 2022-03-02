//
//  TabBarController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/17.
//

import Foundation
import UIKit


class TabBarController: UITabBarController {
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // TabBarController를 rootViewController 로 지정
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        keyWindow?.rootViewController = self
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        homeViewController.tabBarItem = UITabBarItem(title:"홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        
        let myInfoViewController = UINavigationController(rootViewController: MyInfoViewController())
        myInfoViewController.tabBarItem = UITabBarItem(title:"내정보", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person"))
        
        let sesacShopViewController = UINavigationController(rootViewController: SesacShopViewController())
        sesacShopViewController.tabBarItem = UITabBarItem(title: "새싹샵", image: UIImage(named: "gift_ic"), selectedImage: UIImage(named: "gift_ic"))
        
        
        viewControllers = [ homeViewController, sesacShopViewController, myInfoViewController ]
        
    }
}


extension CALayer {

    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}

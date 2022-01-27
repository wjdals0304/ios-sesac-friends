//
//  MyInfoDetailViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/26.
//

import Foundation
import UIKit


class MyInfoDetailViewController : UIViewController {
    
    let profileViewHeight : CGFloat = 252

    private lazy var profileView = ProfileView(profileImage: "man", nick: "테스트", profileHeight: profileViewHeight)
    
    private lazy var profileSubViewWidth: CGFloat = self.view.frame.width - 32
    private lazy var profileSubView = ProfileSubView(viewWidth: profileSubViewWidth)

    private var isExpand = false

    var butttonImage: String {
        return isExpand ? "chevron.down" : "chevron.up"
    }

    override func viewDidLoad() {
        view.backgroundColor = .white
        setup()
        setupConstraint()
    }
    
    func setup() {
        [
            profileView
//            profileSubView
        ].forEach{ view.addSubview($0) }
             
//        self.profileView.showMoreButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)

    }
    
    func setupConstraint() {
        
        profileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo( self.view.frame.width - 32)
            $0.height.equalTo(profileViewHeight)
        }
        
//        profileSubView.snp.makeConstraints {
//            $0.top.equalTo(profileView.snp.bottom)
//            $0.leading.equalTo(profileView.snp.leading)
//            $0.trailing.equalTo(profileView.snp.trailing)
//            $0.width.equalTo(profileView.snp.width)
//            $0.height.equalTo(0)
//        }
//
    }
    
    
    
}

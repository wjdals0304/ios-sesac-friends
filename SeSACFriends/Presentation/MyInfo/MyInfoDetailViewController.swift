//
//  MyInfoDetailViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/26.
//

import Foundation
import UIKit
import SnapKit

class MyInfoDetailViewController : UIViewController {
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    let contentView = UIView()
    
    
    let profileViewHeight : CGFloat = 252

    private lazy var profileView = ProfileView(profileImage: "man", nick: "테스트", profileHeight: profileViewHeight)
    
    let textContentView : UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        return view
    }()
    
    let genderLabel : UILabel = {
       let label = UILabel()
        label.text = "text"
        return label
    }()
    let genderLabel2 : UILabel = {
       let label = UILabel()
        label.text = "text"
        return label
    }()
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setup()
        setupConstraint()
    }
    
    func setup() {
    
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        self.contentView.addSubview(profileView)
        self.contentView.addSubview(textContentView)
        
        [
            genderLabel,
            genderLabel2
        ].forEach { textContentView.addSubview($0)}

    }
    
    func setupConstraint() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(self.scrollView.snp.width)
            make.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
            make.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo( view.frame.width - 32)
            $0.height.equalTo(profileViewHeight)
        }
        
        textContentView.snp.makeConstraints {
            $0.top.equalTo(self.profileView.profileSubView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.height.equalTo(500)
            
        }
        
        genderLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().offset(20)
            
        }
           
        genderLabel2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)

        }
    
        
        
        
    }
    
    
}

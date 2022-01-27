//
//  ProfileView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/26.
//

import Foundation
import UIKit
import SnapKit

class ProfileView : UIView {
    
    private let profileImage: String
    private let nick: String
    
    private let profileViewHight : CGFloat
    let profileImgHeight : CGFloat = 194
        
    private var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var nickLabel: UILabel = {
       let label = UILabel()
       label.text = "\(nick)"
       label.font = UIFont.getRegularFont(.medium_16)
       label.frame.size = label.intrinsicContentSize
       return label
    }()

    private lazy var profileImageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "\(profileImage)")
        return image
    }()
    
    private lazy var profileMainView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.getColor(.grayLineColor).cgColor
        return view
    }()

//    private lazy var profileSubViewWidth : CGFloat = self.frame.width - 32
//
//    let profileSubView = ProfileSubView(viewWidth: 200)
    
    private lazy var profileSubView : UIView = {
       let view = UIView()
        view.layer.borderWidth = 1
        return view
    }()
    
    let showMoreButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        return button
    }()

    
    
    
    private var isExpand = false
    
    var butttonImage: String {
        return isExpand ? "chevron.down" : "chevron.up"
    }
    
    
    init(profileImage: String, nick: String , profileHeight: CGFloat) {
        self.profileImage = profileImage
        self.nick = nick
        self.profileViewHight = profileHeight
        super.init(frame: .zero)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        
        [
            profileImageView,
            profileMainView,
            profileSubView
        ].forEach{ addSubview($0) }
        
        [
          nickLabel,
          showMoreButton
        ].forEach { profileMainView.addSubview($0) }
        

//        [
//            titleView,
//            collectionView
//        ].forEach { profileSubView.addSubview($0)}
//
//        titleView.addSubview(titleLabel)
//
        profileImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(profileImgHeight)
        }
        
        profileMainView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo( profileViewHight - profileImgHeight )
        }

        nickLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        showMoreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(26)
            $0.centerY.equalTo(nickLabel.snp.centerY)
        }

//        profileSubView.snp.makeConstraints {
//            $0.top.equalTo(profileMainView.snp.bottom)
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(0)
//        }


    }

    
    @objc func buttonTap() {
        
        if isExpand {
            animateView(isExpand: false , buttonImage: butttonImage, heightConstraint: 0)
        } else {
            animateView(isExpand: true, buttonImage: butttonImage, heightConstraint: 300)
        }
    
    
    }
    
    func animateView(isExpand: Bool,buttonImage: String, heightConstraint: Double){
          
       self.isExpand = isExpand
        
       self.profileSubView.snp.updateConstraints {
           $0.height.equalTo(heightConstraint)
       }
        
        self.showMoreButton.setImage(UIImage(systemName: buttonImage), for: .normal)

        UIView.animate(withDuration: 0.2) {
           self.layoutIfNeeded()
       }
    }
    
}


            

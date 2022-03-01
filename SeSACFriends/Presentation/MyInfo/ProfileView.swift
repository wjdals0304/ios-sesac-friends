//
//  ProfileView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/26.
//

import Foundation
import UIKit
import SnapKit

class ProfileView: UIView {
    
    private let profileImage: String
    private let userData: User
    private let profileViewHight: CGFloat
    let profileImgHeight: CGFloat = 194
   
    private lazy var nickLabel: UILabel = {
       let label = UILabel()
       label.text = "\(userData.nick)"
       label.font = UIFont.getRegularFont(.medium_16)
       label.frame.size = label.intrinsicContentSize
       return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "\(profileImage)")
        return image
    }()
    
    private lazy var profileMainView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.getColor(.grayLineColor).cgColor
        return view
    }()
    
    let showMoreButton: UIImageView = {
        
        let image = UIImageView()
        image.image = UIImage(systemName: "chevron.down")
        image.tintColor = .black
        return image
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "새싹 타이틀"
        label.frame.size = label.intrinsicContentSize
        return label
    }()
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "새싹리뷰"
        label.frame.size = label.intrinsicContentSize
        return label
    }()
    
    let reviewTextLabel: UILabel = {
        let label = UILabel()
        label.text = "첫 리뷰를 기다리는 중이에요!"
        label.font = UIFont.getRegularFont(.regular_14)
        label.textColor = UIColor.getColor(.inactiveColor)
        return label
    }()
    
    var superViewCompletion: ( () -> Void)?

    let collectionTitleData = [ "좋은 매너", "정확한 시각 약속", "빠른 응답", "친절한 성격", "능숙한 취미 실력", "유익한 시간"]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 5)
        // 셀간 거리
        layout.minimumInteritemSpacing = 5
          // 줄 간의 거리 (단위는 포인트)
        layout.minimumLineSpacing = 5
        
        let halfWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        layout.estimatedItemSize = CGSize(width: halfWidth - 40, height: 32)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private var isExpand = false
    
    var butttonImage: String {
        return isExpand ? "chevron.down" : "chevron.up"
    }
    
    init(profileImage: String, userData: User, profileHeight: CGFloat) {
        self.profileImage = profileImage
        self.userData = userData
        self.profileViewHight = profileHeight
        super.init(frame: .zero)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(tapHeader) )
        
        profileMainView.addGestureRecognizer(tapGestureRecognizer)
        
        [
            profileImageView,
            profileMainView
        ].forEach { addSubview($0) }
        
        [
          nickLabel,
          showMoreButton,
          titleLabel,
          collectionView,
          reviewLabel,
          reviewTextLabel
        ].forEach { profileMainView.addSubview($0) }
        
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
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(nickLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(0)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(self.snp.trailing).inset(16)
            $0.height.equalTo(0)
        }
        
        reviewLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(24)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.height.equalTo(0)
        }
        
        reviewTextLabel.snp.makeConstraints {
            $0.top.equalTo(reviewLabel.snp.bottom).offset(16)
            $0.leading.equalTo(reviewLabel.snp.leading)
            $0.height.equalTo(0)
        }
        
   }

    @objc func tapHeader() {
        
        let zeroHeightDict: [String: Double] = ["view": profileViewHight, "profileMainView": profileViewHight - profileImgHeight, "titleLabel": 0, "collectionView": 0, "reviewLabel": 0, "reviewTextLabel": 0]
        
        let updateHeightDict: [String: Double] = ["view": profileViewHight + 310 - (profileViewHight - profileImgHeight), "profileMainView": 310, "titleLabel": 18, "collectionView": 120, "reviewLabel": 18, "reviewTextLabel": 24]
       
        if isExpand {
            animateView(isExpand: false, buttonImage: butttonImage, heightConstraint: zeroHeightDict )
        } else {
            animateView(isExpand: true, buttonImage: butttonImage, heightConstraint: updateHeightDict)
        }

    }
    
    func animateView(isExpand: Bool, buttonImage: String, heightConstraint: Dictionary<String, Double>) {
          
       self.isExpand = isExpand
        
       self.profileMainView.snp.updateConstraints {
           $0.height.equalTo(heightConstraint["profileMainView"]!)
       }
     
        self.titleLabel.snp.updateConstraints {
            $0.height.equalTo(heightConstraint["titleLabel"]!)
        }
        self.collectionView.snp.updateConstraints {
            $0.height.equalTo(heightConstraint["collectionView"]!)

        }
        self.reviewLabel.snp.updateConstraints {
            $0.height.equalTo(heightConstraint["reviewLabel"]!)
        }
        
        self.reviewTextLabel.snp.updateConstraints {
            $0.height.equalTo(heightConstraint["reviewTextLabel"]!)
        }
        
        self.snp.updateConstraints {
            $0.height.equalTo(heightConstraint["view"]!)
        }
        
        self.showMoreButton.image = UIImage(systemName: buttonImage)

        UIView.animate(withDuration: 0.3) {
            self.superViewCompletion?()
        }
        
    }
    
    func getProfileMainView() -> UIView {
        return profileMainView
    }
}

extension ProfileView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 8
        
        cell.textLabel.text = collectionTitleData[indexPath.row]
        
        if userData.reputation[indexPath.row] >= 1 {
            cell.layer.backgroundColor = UIColor.getColor(.activeColor).cgColor
            cell.textLabel.textColor = UIColor.getColor(.whiteTextColor)
        } else {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.getColor(.inactiveColor).cgColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionTitleData.count
    }
}

            
class ProfileCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProfileCollectionViewCell"

    var textLabel: UILabel = {
       let text = UILabel()
        text.font = UIFont.getRegularFont(.regular_14)
        text.textColor = UIColor.getColor(.defaultTextColor)
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [
            textLabel
        ].forEach {addSubview($0) }
       
        textLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

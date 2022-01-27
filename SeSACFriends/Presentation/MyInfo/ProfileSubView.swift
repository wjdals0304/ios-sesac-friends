////
////  ProfileSubView.swift
////  SeSACFriends
////
////  Created by 김정민 on 2022/01/27.
////

import Foundation
import UIKit
import SnapKit

class ProfileSubView : UIView {
    
    private let viewWidth : CGFloat
    
    let titleLabel : UILabel = {
       let label = UILabel()
        label.text = "새싹 타이틀"
        return label
    }()
    
    let collectionTitleData = [ "좋은 매너" , "정확한 시각 약속" , "빠른 응답" ,"친절한 성격" ,"능숙한 취미 실력" ,"유익한 시간"]
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: viewWidth / 2  - 32 , height: 32)
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        
        return collectionView
    }()
    

    let reviewLabel : UILabel = {
       let label = UILabel()
        label.text = "새싹 리뷰"
       return label
    }()
    
    init(viewWidth : CGFloat) {
        self.viewWidth = viewWidth
        
        super.init(frame: .zero)
        self.setupConstraints()
        self.backgroundColor = .black

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        
        [
          titleLabel,
          collectionView,
//          reviewLabel
        ].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.height.equalTo(0)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        
//        reviewLabel.snp.makeConstraints {
//            $0.top.equalTo(collectionView.snp.bottom).offset(24)
//        }
        
    }
    
}

extension ProfileSubView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.textLabel.text = collectionTitleData[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionTitleData.count
    }
}

            

class ProfileSubCollectionViewCell : UICollectionViewCell {
    
    static let identifier = "ProfileSubCollectionViewCell"

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
        ].forEach{addSubview($0)}
       
        textLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

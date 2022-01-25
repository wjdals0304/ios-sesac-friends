//
//  MyInfoViewController.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/01/25.
//

import Foundation
import SnapKit
import UIKit


class MyInfoViewController: UIViewController {
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: self.view.frame.width - 20 , height: 74)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MyInfoCollectionViewCell.self, forCellWithReuseIdentifier: MyInfoCollectionViewCell.identifier)
        collectionView.register(MyInfoCollectionHeaderVIew.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyInfoCollectionHeaderVIew.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    
        
        return collectionView
    }()
    
    let imageArray = ["notice","faq","qna","setting_alarm","permit"]
    let textArray = ["공지사항","자주 묻는 질문","1:1 문의","알람 설정","이용 약관" ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "내정보"

        setup()
        setupConstraint()
    }
    
    func setup() {
        
        [
          collectionView
        ].forEach { view.addSubview($0) }
        
    }
    
    func setupConstraint() {
        
    
                
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
////            make.leading.trailing.bottom.equalToSuperview()
            
        }
        
    }
    
    
}

extension MyInfoViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInfoCollectionViewCell.identifier, for: indexPath) as? MyInfoCollectionViewCell  else { return UICollectionViewCell() }
        
      
        
        let image = imageArray[indexPath.row]
        let text = textArray[indexPath.row]
        
        
        cell.setup(image: image, text: text)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
          case UICollectionView.elementKindSectionHeader :
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyInfoCollectionHeaderVIew.identifier, for: indexPath) as? MyInfoCollectionHeaderVIew else {
                return UICollectionReusableView()
            }
            
            header.update()
            return header

        default :
            return UICollectionReusableView()
        }

    }
    
    
}

extension MyInfoViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        print("bb")
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 100
        return CGSize(width: width, height: height)
    }
}

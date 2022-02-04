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
    
    private var userData : User!
    
    init(user: User) {
        self.userData = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: self.view.frame.width - 20 , height: 74)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MyInfoCollectionViewCell.self, forCellWithReuseIdentifier: MyInfoCollectionViewCell.identifier)
        collectionView.register(MyInfoCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyInfoCollectionHeaderView.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    
        
        return collectionView
    }()
    
    let imageArray = ["notice","faq","qna","setting_alarm","permit"]
    let textArray = ["공지사항","자주 묻는 질문","1:1 문의","알람 설정","이용 약관" ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "내정보"

        
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
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
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
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyInfoCollectionHeaderView.identifier, for: indexPath) as? MyInfoCollectionHeaderView else {
                return UICollectionReusableView()
            }


            let tapGestureRecognizer = UITapGestureRecognizer(target:self,action:#selector(tapHeader))
            
            header.addGestureRecognizer(tapGestureRecognizer)
            header.update(userData: userData)
           
        
            return header

        default :
            return UICollectionReusableView()
        }

    }
    
    @objc func tapHeader() {
        
        let vc = MyInfoDetailViewController(userData: userData)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension MyInfoViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 100
        return CGSize(width: width, height: height)
    }
}

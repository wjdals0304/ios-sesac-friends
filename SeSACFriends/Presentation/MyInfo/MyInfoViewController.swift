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
    
    let myInfoViewModel = MyInfoViewModel()
    
    private var userData : User?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: self.view.frame.width - 20, height: 74)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MyInfoCollectionViewCell.self, forCellWithReuseIdentifier: MyInfoCollectionViewCell.identifier)
        collectionView.register(MyInfoCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyInfoCollectionHeaderView.identifier)

        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "내정보"
        view.backgroundColor = .systemBackground

        setup()
        setupConstraint()
    }

    override func viewDidAppear(_ animated: Bool) {
        getUser()
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

    func getUser() {
        
        myInfoViewModel.getUser(idtoken: UserManager.idtoken!) { user, APIStatus in
            
            switch APIStatus {
                
            case .success :
                
                    guard let user = user else {
                        return
                    }
                    self.userData = user
                    self.collectionView.dataSource = self
                    self.collectionView.delegate = self
                
            case .unregisterdUser :
                   return
                
            case .expiredToken :
                    
                    AuthNetwork.getIdToken { error  in
                        
                        switch error {
                        case .success :
                            self.getUser()
                        case .failed :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        default :
                            self.view.makeToast(APIErrorMessage.failed.rawValue)
                        }
                    }
                
            default:
                self.view.makeToast("에러가 발생했습니다. 잠시 후 다시 시도해주세요.")
            }
                

        }
        
    }

}

extension MyInfoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myInfoViewModel.textArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInfoCollectionViewCell.identifier, for: indexPath) as? MyInfoCollectionViewCell  else { return UICollectionViewCell() }
        
        let image = myInfoViewModel.imageArray[indexPath.row]
        let text = myInfoViewModel.textArray[indexPath.row]
        
        cell.setup(image: image, text: text)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader :
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyInfoCollectionHeaderView.identifier, for: indexPath) as? MyInfoCollectionHeaderView else {
                return UICollectionReusableView()
            }

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(tapHeader))
            
            header.addGestureRecognizer(tapGestureRecognizer)
            header.update(userData: userData!)
 
            return header

        default :
            return UICollectionReusableView()
        }

    }
    
    @objc func tapHeader() {
        
        let vc = MyInfoDetailViewController(userData: userData!)
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

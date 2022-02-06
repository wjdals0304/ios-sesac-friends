//
//  HobbyTableViewCell.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/06.
//

import Foundation
import UIKit
import SnapKit

class HobbyTableViewCell: UITableViewCell {
    
    lazy var collectionView : UICollectionView = {
        
        let layout = HobbyCollectionViewFlowLayout()
        let collectionView = HobbyDynamicHeightCollectionView(frame: self.frame ,collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(HobbyCollectionViewCell.self, forCellWithReuseIdentifier: HobbyCollectionViewCell.identifier)

        return collectionView
    }()
    
    var aroundHobbyArray = [String]()
    var myHobbyArray = [String]()
    
    
    static let identifier = "HobbyTableViewCell"
    
    func configure(around aroundHobbyArray: [String] , my myHobbyArray:[String]) {
        
        self.aroundHobbyArray = aroundHobbyArray
        self.myHobbyArray = myHobbyArray
        
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension HobbyTableViewCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.aroundHobbyArray.count
        } else {
            return self.myHobbyArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyCollectionViewCell.identifier, for: indexPath) as! HobbyCollectionViewCell
        
        if indexPath.section == 0 {
            cell.textLabel.text = self.aroundHobbyArray[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel.text = self.myHobbyArray[indexPath.row]
        }
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var text = ""
        if indexPath.section == 0 {
            text = self.aroundHobbyArray[indexPath.row]
            
        } else if indexPath.section == 1 {
            text = self.myHobbyArray[indexPath.row]
        }
        
        
        let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:12.0)]).width + 30.0
        
        
        return CGSize(width: cellWidth, height: 30.0)
        
    }
    
    
    
}

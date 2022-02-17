//
//  HobbyTableViewCell.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/06.
//

import Foundation
import UIKit
import SnapKit


protocol CollectionViewCellDelegate: AnyObject {
    
    func collectionView(collectionviewcell: HobbyCollectionViewCell?, index: Int, didTappedInTableViewCell: HobbyTableViewCell)
    func changeHobby(addCollectionViewModel: CollectionViewCellModel , addCategory : Int )
    func showContainToast()
    func showCountToast()
    
    
}

class HobbyTableViewCell: UITableViewCell {
    
    weak var cellDelegate: CollectionViewCellDelegate?
    
    var rowWithHobbys : [CollectionViewCellModel]?

    lazy var collectionView : UICollectionView = {
        
        let layout = HobbyCollectionViewFlowLayout()
        
        let collectionView = HobbyDynamicHeightCollectionView(frame: self.frame ,collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.register(HobbyCollectionViewCell.self, forCellWithReuseIdentifier: HobbyCollectionViewCell.identifier)

        return collectionView
    }()
    
    var myHobbyArray = UserManager.myHobbyArray
    
    var fromRecommendArray = [String]()
    var hobbyArray = [String]()
    var arroundArray = [String]()
    var hobbyType = ""
    
    static let identifier = "HobbyTableViewCell"
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(50)
            make.bottom.equalToSuperview()
        }
        
        self.contentView.isUserInteractionEnabled = false

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension HobbyTableViewCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    func updateCellWith(row: [CollectionViewCellModel] , fromRecommendArray : [String]) {
        self.rowWithHobbys = row
        self.fromRecommendArray = fromRecommendArray 
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rowWithHobbys?.count ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbyCollectionViewCell.identifier, for: indexPath) as! HobbyCollectionViewCell

        if  self.rowWithHobbys![indexPath.row].subcategory == 1 {
            cell.setupMyHobby(with: self.rowWithHobbys![indexPath.row].name )
        } else {
            cell.setup(with:self.rowWithHobbys![indexPath.row].name ,from : fromRecommendArray)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        var cellWidth : CGFloat
        
        if  self.rowWithHobbys![indexPath.row].subcategory == 1 {
            cellWidth = self.rowWithHobbys![indexPath.row].name.size(withAttributes:[.font: UIFont.getRegularFont(.regular_14)]).width + 30.0 + 20

       } else {
           cellWidth = self.rowWithHobbys![indexPath.row].name.size(withAttributes:[.font: UIFont.getRegularFont(.regular_14)]).width + 30.0
       }
        
      return CGSize(width: cellWidth, height: 30)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as? HobbyCollectionViewCell
        
        
        // 내가 하고 싶은 셀 삭제
        if self.rowWithHobbys![indexPath.row].subcategory == 1 {
            
            self.rowWithHobbys?.remove(at: indexPath.row)
            UserManager.myHobbyArray.remove(at: indexPath.row)
             
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()

        } else {
        // 지금 주변에는 -> 내가 하고 싶은 추가
            
            let name = self.rowWithHobbys![indexPath.row].name

            if UserManager.myHobbyArray.contains( name ) {
                self.cellDelegate?.showContainToast()
                return
            }
            
            if UserManager.myHobbyArray.count > 8 {
                self.cellDelegate?.showCountToast()
                return
            }
                        
            self.cellDelegate?.changeHobby(addCollectionViewModel: CollectionViewCellModel(name: name, subcategory: HobbyCategory.myHobby.rawValue), addCategory: HobbyCategory.myHobby.rawValue)

                                        
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
            
        }
        
        self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
        
    }

    
    
}

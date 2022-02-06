//
//  HobbyDynamicHeightCollectionView.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/06.
//

import UIKit

class HobbyDynamicHeightCollectionView : UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize){
                self.invalidateIntrinsicContentSize()
            }
        
    
    }
        
    
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
}

//
//  HobbyCollectionViewFlowLayout.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/06.
//

import Foundation
import UIKit

class HobbyCollectionViewFlowLayout : UICollectionViewFlowLayout {
    
    var tempCellAttributesArray = [UICollectionViewLayoutAttributes]()
    let leftEdgeInset: CGFloat = 0
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let cellAttributesArray = super.layoutAttributesForElements(in: rect)
    
        

        if(cellAttributesArray != nil && cellAttributesArray!.count > 1) {
            
            for i in 1..<(cellAttributesArray!.count) {
                
                let prevLayoutAttributes: UICollectionViewLayoutAttributes = cellAttributesArray![i - 1]
                
                let currentLayoutAttributes: UICollectionViewLayoutAttributes = cellAttributesArray![i]
                
                let maximumSpacing: CGFloat = 8
                
                let prevCellMaxX: CGFloat = prevLayoutAttributes.frame.maxX
                //UIEdgeInset 30 from left
                let collectionViewSectionWidth = self.collectionViewContentSize.width
                - leftEdgeInset
                
                let currentCellExpectedMaxX = prevCellMaxX + maximumSpacing + (currentLayoutAttributes.frame.size.width )
                
                if currentCellExpectedMaxX < collectionViewSectionWidth {
                    var frame: CGRect? = currentLayoutAttributes.frame
                    frame?.origin.x = prevCellMaxX + maximumSpacing
                    frame?.origin.y = prevLayoutAttributes.frame.origin.y
                    currentLayoutAttributes.frame = frame ?? CGRect.zero
                    
                } else {
//                     self.shiftCellsToCenter()
                    currentLayoutAttributes.frame.origin.x = leftEdgeInset
                    //To Avoid InConvience Emoji Cell
                    if (prevLayoutAttributes.frame.origin.x != 0) {
                        currentLayoutAttributes.frame.origin.y = prevLayoutAttributes.frame.origin.y + prevLayoutAttributes.frame.size.height + 08
                    }
                }

            }
        }

        return cellAttributesArray
    }
    
    func shiftCellsToCenter() {
        
        if (tempCellAttributesArray.count == 0) {return}
        let lastCellLayoutAttributes = self.tempCellAttributesArray[self.tempCellAttributesArray.count-1]
        let lastCellMaxX: CGFloat = lastCellLayoutAttributes.frame.maxX
        let collectionViewSectionWidth = self.collectionViewContentSize.width - leftEdgeInset
        let xAxisDifference = collectionViewSectionWidth - lastCellMaxX
        if xAxisDifference > 0 {
            for each in self.tempCellAttributesArray{
                each.frame.origin.x += xAxisDifference/2
            }
        }
        
    }
    
    
}

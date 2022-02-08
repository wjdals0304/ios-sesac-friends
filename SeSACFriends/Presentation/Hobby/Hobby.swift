//
//  Hobby.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/08.
//

import Foundation


struct Hobby {
    
    var objectsArray : [
        TableViewCellModel
    ]
}


struct TableViewCellModel {
    var category : String
    var texts : [CollectionViewCellModel]
}

struct CollectionViewCellModel {
    var name: String
    var subcategory : Int

}






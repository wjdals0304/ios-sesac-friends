//
//  Hobby.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/08.
//

import Foundation


struct HobbyModel {
    
    var objectsArray : [
        TableViewCellModel
    ]
}


struct TableViewCellModel {
    var category : String
    var texts : [CollectionViewCellModel]
}

struct CollectionViewCellModel : Equatable {
    var name: String
    var subcategory : Int

}


enum HobbyCategory: Int {
    
    case arroundHobby = 0
    case myHobby = 1 
    
}





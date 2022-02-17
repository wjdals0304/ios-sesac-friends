//
//  Date+extension.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/16.
//

import Foundation



extension Date {
    
    
    func dateToString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    
    
    
    
    
}

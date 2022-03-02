//
//  SKProduct+extension.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/23.
//

import Foundation
import UIKit
import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}

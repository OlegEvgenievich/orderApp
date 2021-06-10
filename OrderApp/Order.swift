//
//  Order.swift
//  OrderApp
//
//  Created by Олег Бабыр on 30.05.2021.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}

//
//  OrdersModel.swift
//  Bouquets
//
//  Created by rares.soponar on 13.03.2023.
//

import UIKit
import CoreStore
import Alamofire

class OrdersModel {
    
    var orders: [Order] {
        if let orders = try? DataStackManager.shared.dataStack.fetchAll(From<Order>()) {
            return orders.sorted(by: { $0.id < $1.id })
        } else {
            return []
        }
    }
    
}

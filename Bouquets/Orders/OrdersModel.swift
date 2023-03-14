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
        if let orders = try? OrdersService.shared.dataStack.fetchAll(From<Order>()) {
            return orders
        } else {
            return []
        }
    }
    
}

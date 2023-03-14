//
//  OrdersViewModel.swift
//  Bouquets
//
//  Created by rares.soponar on 13.03.2023.
//

import Foundation
import Alamofire
import CoreStore

class OrdersViewModel {
    
    var ordersModel: OrdersModel?
    
    var orders: [Order] {
        return ordersModel?.orders ?? []
    }
    
}

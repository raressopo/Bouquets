//
//  OrderDetailsModel.swift
//  Bouquets
//
//  Created by rares.soponar on 13.03.2023.
//

import Foundation

class OrderDetailsModel {
    
    var order: Order
    
    init(withOrder order: Order) {
        self.order = order
    }
    
    func changeStatus(to status: OrderStatus, completion: @escaping (OrderStatus) -> Void) {
        OrdersService.shared.changeStatusForOrder(id: order.id, newStatus: status) { newStatus in
            self.order.status = newStatus.rawValue
            
            completion(newStatus)
        }
    }
    
}

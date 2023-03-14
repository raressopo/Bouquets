//
//  OrderDetailsViewModel.swift
//  Bouquets
//
//  Created by rares.soponar on 13.03.2023.
//

import Foundation

class OrderDetailsViewModel {
    
    let model: OrderDetailsModel
    var order: Order {
        return model.order
    }
    
    init(model: OrderDetailsModel) {
        self.model = model
    }
    
    func changeStatus(to status: OrderStatus, completion: @escaping (OrderStatus) -> Void) {
        self.model.changeStatus(to: status, completion: completion)
    }
    
    func customerLatitudeAndLongitude() -> (latitude: Double, longitude: Double)? {
        if let customer = DataStackManager.shared.getCustomerInfo(customerId: order.customerId) {
            return (customer.latitude, customer.longitude)
        } else {
            return nil
        }
    }
    
}

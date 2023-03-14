//
//  OrdersService.swift
//  Bouquets
//
//  Created by rares.soponar on 13.03.2023.
//

import Foundation
import Alamofire

class OrdersService {
    
    private let ordersGET = "https://demo6300010.mockable.io/orders"
    private let orderStatusChangePUT = "https://demo6300010.mockable.io/updateOrderStatus"
    
    static let shared = OrdersService()
    
    func fetchOrders(completion: @escaping () -> Void) {
        AF.request(ordersGET, method: .get).responseDecodable(of: Orders.self) { response in
            switch response.result {
            case .success(let fetchedOrders):
                DataStackManager.shared.saveOrders(orders: fetchedOrders.orders, completion: completion)
            case .failure(_):
                print("Fetch failed")
            }
        }
    }
    
    func changeStatusForOrder(id: Int16, newStatus: OrderStatus, completion: @escaping (OrderStatus) -> Void) {
        AF.request(orderStatusChangePUT).response { response in
            switch response.result {
            case .success(_):
                DataStackManager.shared.updateOrderStatus(forOrderId: id,
                                                          newStatus: newStatus,
                                                          completion: completion)
            case .failure(_):
                print("Change Status failed")
            }
        }
    }
    
}

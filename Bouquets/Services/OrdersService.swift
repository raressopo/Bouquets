//
//  OrdersService.swift
//  Bouquets
//
//  Created by rares.soponar on 13.03.2023.
//

import Foundation
import CoreStore
import Alamofire

class OrdersService {
    
    private let ordersGET = "https://demo6300010.mockable.io/orders"
    private let orderStatusChangePUT = "https://demo6300010.mockable.io/updateOrderStatus"
    
    let dataStack = DataStack(xcodeModelName: "Bouquets")
    
    static let shared = OrdersService()
    
    func setupStorage() {
        do {
            try dataStack.addStorageAndWait(SQLiteStore(fileName: "Bouquets.sqlite"))
        }
        catch {}
    }
    
    func fetchOrdersAndStoreThemInDB(completion: @escaping () -> Void) {
        AF.request(ordersGET, method: .get).responseDecodable(of: Orders.self) { response in
            switch response.result {
            case .success(let fetchedOrders):
                let dispatchGroup = DispatchGroup()
                
                fetchedOrders.orders?.forEach({ fetchedOrder in
                    let order = try? self.dataStack.fetchOne(From<Order>().where(\.id == Int16(fetchedOrder.id)))
                        
                        if order == nil {
                            dispatchGroup.enter()
                            
                            self.dataStack.perform(asynchronous: { transaction in
                                let order = transaction.create(Into<Order>())
                                
                                order.id = Int16(fetchedOrder.id)
                                order.status = fetchedOrder.status?.rawValue
                                
                                if let price = fetchedOrder.price {
                                    order.price = price
                                }
                                
                                order.orderDescription = fetchedOrder.orderDescription
                                order.customerId = Int16(fetchedOrder.customerId)
                                
                                if let imageUrl = fetchedOrder.imageUrl, let url = URL(string: imageUrl) {
                                    do {
                                        let data = try Data(contentsOf: url)
                                        
                                        order.image = data
                                    } catch {
                                        // handle error
                                    }
                                }
                            }, completion: { _ in
                                dispatchGroup.leave()
                            })
                        }
                })
                
                dispatchGroup.notify(queue: .main) {
                    completion()
                }
            case .failure(_):
                print("Fetch failed")
            }
        }
    }
    
    func changeStatusForOrder(id: Int16, newStatus: OrderStatus, completion: @escaping (OrderStatus) -> Void) {
        AF.request(orderStatusChangePUT).response { response in
            switch response.result {
            case .success(_):
                self.dataStack.perform { transaction in
                    let order = try? transaction.fetchOne(From<Order>().where(\.id == id))
                    
                    order?.status = newStatus.rawValue
                } completion: { result in
                    switch result {
                    case .success:
                        completion(newStatus)
                    case .failure(_):
                        print("CoreStore Error")
                    }
                }
            case .failure(_):
                print("Change Status failed")
            }
        }
    }
    
}

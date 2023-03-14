//
//  DataStackManager.swift
//  Bouquets
//
//  Created by rares.soponar on 13.03.2023.
//

import Foundation
import CoreStore

class DataStackManager {
    
    let dataStack = DataStack(xcodeModelName: "Bouquets")
    
    static let shared = DataStackManager()
    
    func setupStorage(completion: (() -> Void)?) {
        _ = dataStack.addStorage(SQLiteStore(fileName: "Bouquets.sqlite"), completion: { result in
            switch result {
            case .success(_):
                completion?()
            case .failure(_):
                print("Store initialization failed")
            }
        })
    }
    
    func saveOrders(orders: [CustomerOrder]?, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        orders?.forEach({ fetchedOrder in
            let order = try? self.dataStack.fetchOne(From<Order>().where(\.id == Int16(fetchedOrder.id)))
            
            if order == nil {
                dispatchGroup.enter()
                
                dataStack.perform(asynchronous: { transaction in
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
    }
    
    func updateOrderStatus(forOrderId id: Int16, newStatus: OrderStatus, completion: @escaping (OrderStatus) -> Void) {
        dataStack.perform { transaction in
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
    }
    
    func saveCustomers(customers: [Customer], completion: (() -> Void)?) {
        let dispatchGroup = DispatchGroup()
        
        customers.forEach { fetchedCustomer in
            let existingCustomer = try? dataStack.fetchOne(From<CustomerDB>().where(\.id == Int16(fetchedCustomer.id)))
            
            if existingCustomer == nil {
                dispatchGroup.enter()
                
                dataStack.perform { transaction in
                    let customer = transaction.create(Into<CustomerDB>())
                    
                    customer.id = Int16(fetchedCustomer.id)
                    customer.name = fetchedCustomer.name
                    
                    if let latitude = fetchedCustomer.latitude {
                        customer.latitude = latitude
                    }
                    
                    if let longitude = fetchedCustomer.longitude {
                        customer.longitude = longitude
                    }
                } completion: { _ in
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?()
        }
    }
    
    func getCustomerInfo(customerId id: Int16) -> CustomerDB? {
        return try? dataStack.fetchOne(From<CustomerDB>().where(\.id == id))
    }
    
}

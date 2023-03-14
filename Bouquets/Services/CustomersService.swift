//
//  CustomersService.swift
//  Bouquets
//
//  Created by rares.soponar on 13.03.2023.
//

import Foundation
import Alamofire

class CustomersService {
    
    private let customersGET = "https://demo6300010.mockable.io/customers"
    
    static let shared = CustomersService()
    
    func fetchCustomers(completion: (() -> Void)?) {
        AF.request(customersGET, method: .get).responseDecodable(of: Customers.self) { response in
            switch response.result {
            case .success(let customers):
                DataStackManager.shared.saveCustomers(customers: customers.customers, completion: completion)
            case .failure(_):
                print("Customers fetch failed")
                completion?()
            }
        }
    }
    
}

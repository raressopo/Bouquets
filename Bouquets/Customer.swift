//
//  Customer.swift
//  Bouquets
//
//  Created by rares.soponar on 13.03.2023.
//

import Foundation

struct Customer: Codable {
    
    let id: Int
    let name: String?
    let latitude: Double?
    let longitude: Double?
    
}

struct Customers: Codable {
    
    let customers: [Customer]
    
}

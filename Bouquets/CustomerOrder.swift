//
//  Order.swift
//  Bouquets
//
//  Created by rares.soponar on 12.03.2023.
//

import Foundation

enum OrderStatus: String, Codable {
    case new
    case pending
    case delivered
}

struct CustomerOrder: Codable {
    
    let id: String?
    let description: String?
    let price: Double?
    let customerId: String?
    let imageUrl: String?
    let status: OrderStatus?
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case price
        case customerId = "customer_id"
        case imageUrl = "image_url"
        case status
    }
    
}

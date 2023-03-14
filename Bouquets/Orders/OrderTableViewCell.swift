//
//  OrderTableViewCell.swift
//  Bouquets
//
//  Created by rares.soponar on 13.03.2023.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderDescription: UILabel!
    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    
    func configure(withDescription description: String?, image: UIImage?, price: Double?, status: OrderStatus?) {
        orderDescription.text = description
        orderImageView.image = image
        orderPrice.text = "\(price ?? 0.0)"
        orderStatus.text = status?.rawValue
    }
    
}

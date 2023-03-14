//
//  OrdersViewControllersFactory.swift
//  Bouquets
//
//  Created by rares.soponar on 13.03.2023.
//

import UIKit

class OrdersViewControllersFactory {
    
    static func ordersViewController() -> OrdersViewController? {
        let ordersModel = OrdersModel()
        let ordersViewModel = OrdersViewModel(ordersModel: ordersModel)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ordersVC") as? OrdersViewController
        
        viewController?.viewModel = ordersViewModel
        
        return viewController
    }
    
    static func orderDetailsViewController(withOrder order: Order) -> OrderDetailsViewController? {
        let orderDetailsModel = OrderDetailsModel(withOrder: order)
        let orderDetailsViewModel = OrderDetailsViewModel(model: orderDetailsModel)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let orderDetailsVC = storyboard.instantiateViewController(withIdentifier: "orderDetailsVC") as? OrderDetailsViewController
        
        orderDetailsVC?.viewModel = orderDetailsViewModel
        
        return orderDetailsVC
    }
    
}

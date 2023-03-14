//
//  OrdersViewController.swift
//  Bouquets
//
//  Created by rares.soponar on 12.03.2023.
//

import UIKit
import Alamofire
import CoreStore

class OrdersViewController: UIViewController {
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    var viewModel: OrdersViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshOrders), name: Notification.Name("StatusUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshOrders), name: Notification.Name("OrdersFetchComplete"), object: nil)
    }
    
    @objc private func refreshOrders() {
        ordersTableView.reloadData()
    }
}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.orders.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as? OrderTableViewCell else {
            fatalError("The cell should be OrderTableViewCell type")
        }
        
        if let order = viewModel?.orders[indexPath.row] {
            var orderImage: UIImage?
            
            if let imageData = order.image, let image = UIImage(data: imageData) {
                orderImage = image
            }
            
            cell.configure(withDescription: order.orderDescription,
                           image: orderImage,
                           price: order.price,
                           status: OrderStatus(rawValue: order.status ?? ""))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let order = viewModel?.orders[indexPath.row] else { return }
        
        if let orderDetailsVC = OrdersViewControllersFactory.orderDetailsViewController(withOrder: order) {
            self.navigationController?.pushViewController(orderDetailsVC, animated: true)
        }
    }
    
}


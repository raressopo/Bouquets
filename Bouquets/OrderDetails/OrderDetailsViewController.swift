//
//  OrderDetailsViewController.swift
//  Bouquets
//
//  Created by rares.soponar on 13.03.2023.
//

import UIKit
import MapKit

class OrderDetailsViewController: UIViewController {
    
    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var orderDescription: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var viewModel: OrderDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        mapView.delegate = self
    }
    
    @IBAction func changeStatusPressed(_ sender: Any) {
        let orderStatusView = ChangeOrderStatusView()
        
        orderStatusView.delegate = self
        orderStatusView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(orderStatusView)
        
        NSLayoutConstraint.activate([orderStatusView.topAnchor.constraint(equalTo: view.topAnchor),
                                     orderStatusView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     orderStatusView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     orderStatusView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    @IBAction func getDirectionsPressed(_ sender: Any) {
        guard let customerCoordinate = viewModel?.customerLatitudeAndLongitude() else { return }
        
        mapView.isHidden = false
        distanceLabel.isHidden = false
        
        let coordinate1 = CLLocationCoordinate2D(latitude: 46.779596, longitude: 23.595281)
        let coordinate2 = CLLocationCoordinate2D(latitude: customerCoordinate.latitude, longitude: customerCoordinate.longitude)
        
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = coordinate1
        annotation1.title = "Flower Store"
        self.mapView.addAnnotation(annotation1)
        
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = coordinate2
        annotation2.title = "Customer"
        self.mapView.addAnnotation(annotation2)
        
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinate1, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate2, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = [.automobile, .walking]
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            if let route = unwrappedResponse.routes.first {
                distanceLabel.text = "Distance to customer is: \(String(format: "%.2f", route.distance / 1000)) km"
                
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
            }
        }
    }
    
    fileprivate func configureUI() {
        guard let order = self.viewModel?.order else { return }
        
        if let imageData = order.image, let fetchedImage = UIImage(data: imageData) {
            orderImageView.image = fetchedImage
        }
        
        orderDescription.text = order.orderDescription
        orderPrice.text = "\(order.price)"
        orderStatus.text = order.status
        
    }
    
}

extension OrderDetailsViewController: ChangeOrderStatusViewDelegate {
    
    func orderStatusChanged(toStatus status: OrderStatus) {
        viewModel?.changeStatus(to: status, completion: { newStatus in
            self.orderStatus.text = newStatus.rawValue
            
            let notificationName = Notification.Name("StatusUpdated")
            NotificationCenter.default.post(name: notificationName, object: nil)
        })
    }
    
}

extension OrderDetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 5.0
        return renderer
    }
}

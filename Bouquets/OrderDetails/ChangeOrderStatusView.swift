//
//  ChangeOrderStatusView.swift
//  Bouquets
//
//  Created by rares.soponar on 13.03.2023.
//

import UIKit

protocol ChangeOrderStatusViewDelegate: AnyObject {
    func orderStatusChanged(toStatus status: OrderStatus)
}

class ChangeOrderStatusView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    
    weak var delegate: ChangeOrderStatusViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ChangeOrderStatusView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func dismissViewPressed(_ sender: Any) {
        removeFromSuperview()
    }
    
    
    @IBAction func newStatusPressed(_ sender: Any) {
        self.delegate?.orderStatusChanged(toStatus: .new)
        
        removeFromSuperview()
    }
    
    @IBAction func pendingStatusChanged(_ sender: Any) {
        self.delegate?.orderStatusChanged(toStatus: .pending)
        
        removeFromSuperview()
    }
    
    @IBAction func deliveredStatusPressed(_ sender: Any) {
        self.delegate?.orderStatusChanged(toStatus: .delivered)
        
        removeFromSuperview()
    }
    
}

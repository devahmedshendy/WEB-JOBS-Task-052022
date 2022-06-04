//
//  TabBarController.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 02/06/2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    private lazy var shadowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        
        layer.masksToBounds = false
        layer.fillColor = UIColor.white.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 10.0 / 2.0
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.withAlphaComponent(0.16) .cgColor
        layer.shadowPath = nil
        layer.path = nil
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        return layer
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard shadowLayer.path == nil else { return }
        
        shadowLayer.path = UIBezierPath(
            rect: CGRect(
                x: self.tabBar.bounds.minX,
                y: self.tabBar.bounds.minY,
                width: self.tabBar.bounds.width,
                height: self.tabBar.bounds.height
            )
        ).cgPath
    }
}

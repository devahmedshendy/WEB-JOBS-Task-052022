//
//  ShowResultsButtonContainer.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 03/06/2022.
//

import UIKit

class ShowResultsButtonContainer: UIView {
    
    // MARK: - Subviews/Sublayers
    
    private lazy var shadowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        
        layer.masksToBounds = false
        layer.fillColor = UIColor.white.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 15.0 / 2.0
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.withAlphaComponent(0.16) .cgColor
        layer.shadowPath = nil
        layer.path = nil
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        return layer
    }()
    
    // MARK: - inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    // MARK: - LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard shadowLayer.path == nil else { return }
        
        shadowLayer.path = UIBezierPath(
            rect: CGRect(
                x: self.bounds.minX,
                y: self.bounds.minY,
                width: self.bounds.width,
                height: self.bounds.height
            )
        ).cgPath
    }
    
    // MARK: - Setup
    
    private func setup() {
        clipsToBounds = false
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
}

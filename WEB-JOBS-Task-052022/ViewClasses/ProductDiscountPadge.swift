//
//  ProductDiscountPadge.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 02/06/2022.
//

import UIKit

//@IBDesignable
class ProductDiscountPadge: UIView {
    
    var value: Int = 30 {
        didSet {
            label.text = "\(value)%"
        }
    }
    
    // MARK: - Subviews/Sublayers
    
    private lazy var label: UILabel! = {
        subviews.first(where: { $0 is UILabel }) as! UILabel
    }()
    
    private lazy var frontLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        
        layer.masksToBounds = false
        layer.backgroundColor = _productPadgeFrontBackgroundColor.cgColor
        layer.fillColor = _productPadgeFrontBackgroundColor.cgColor
        
        layer.shadowPath = nil
        layer.path = nil
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        return layer
    }()
    
    private lazy var backLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        
        layer.masksToBounds = false
        layer.backgroundColor = _productPadgeBackBackgroundColor.cgColor
        layer.fillColor = _productPadgeBackBackgroundColor.cgColor
        
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
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard frontLayer.path == nil else { return }
        
        let frontPath = UIBezierPath(
            roundedRect: CGRect(
                x: self.bounds.minX,
                y: self.bounds.minY,
                width: self.bounds.width,
                height: self.bounds.height
            ),
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10)
        )
        
        let backPath = UIBezierPath()
        backPath.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        backPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        backPath.addLine(to: CGPoint(x: bounds.maxX + 7, y: bounds.minY + 10))
        backPath.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY + 10))
        backPath.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        backPath.close()
        
        frontLayer.path = frontPath.cgPath
        backLayer.path = backPath.cgPath
    }
    
    func setup() {
        layer.insertSublayer(frontLayer, at: 0)
        layer.insertSublayer(backLayer, at: 0)
        
        label.text = "\(value)%"
    }
    
}

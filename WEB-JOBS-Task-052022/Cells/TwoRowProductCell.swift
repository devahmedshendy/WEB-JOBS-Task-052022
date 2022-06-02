//
//  TwoRowProductCell.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 02/06/2022.
//

import UIKit

class TwoRowProductCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = String(describing: TwoRowProductCell.self)
    
    // MARK: - Properties
    
    var dto: ProductDto? {
        didSet {
            guard let dto = dto else { return }
            
            
            _imageView.image = UIImage(named: dto.imageName)!
            nameLabel.text = dto.name
            actionPriceLabel.text = dto.actualPriceString
            actionPriceLabel.isHidden = dto.hasNoDiscount
            
            discountedPriceLabel.text  = dto.discountedPriceString
            
            discountPadge.value = dto.discount
            discountPadge.isHidden = dto.hasNoDiscount
        }
    }
    
    // MARK: - Subviews/Sunlayers
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var discountPadge: ProductDiscountPadge!
    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var actionPriceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    
    private lazy var shadowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.white.cgColor
        layer.fillColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 12.0 / 2.0
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.withAlphaComponent(0.10) .cgColor
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
    
    private func resetShadowLayerPaths() {
        shadowLayer.shadowPath = UIBezierPath(
            roundedRect:  CGRect(
                x: self.bounds.minX,
                y: self.bounds.minY,
                width: self.bounds.width,
                height: self.bounds.height
            ),
            cornerRadius: 5
        ).cgPath
        
        shadowLayer.path = UIBezierPath(
            roundedRect:  CGRect(
                x: self.bounds.minX,
                y: self.bounds.minY,
                width: self.bounds.width,
                height: self.bounds.height
            ),
            cornerRadius: 5
        ).cgPath
    }
    
    override var bounds: CGRect {
        didSet {
            guard bounds != .zero else { return }
            
            resetShadowLayerPaths()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard shadowLayer.path == nil else { return }
        
        resetShadowLayerPaths()
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = .clear

        layer.masksToBounds = false
        layer.insertSublayer(shadowLayer, at: 0)
    }
}

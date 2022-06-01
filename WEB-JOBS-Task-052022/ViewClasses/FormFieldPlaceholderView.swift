//
//  FormFieldPlaceholderView.swift
//  Apollo
//
//  Created by Ahmed Shendy on 10/04/2022.
//

import UIKit

let scaleAnimationKey = "scale"

//@IBDesignable
class FormFieldPlaceholderView: UIView {
    
    // MARK: - Properties
    
    var textAlignment: NSTextAlignment {
        set {
            label.textAlignment = newValue
            updateAnchorPoint(of: label, textAlignment: newValue)
        }
        get {
            return label.textAlignment
        }
    }
    
    override var intrinsicContentSize: CGSize {
        
        let infinite = CGFloat.greatestFiniteMagnitude
        let size = label.systemLayoutSizeFitting(CGSize(width: infinite, height: infinite))
        
        return size
    }
    
    // MARK: - Subviews
    
    private(set) lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = _formPlaceholderColor
        label.font = UIFont(name: "Avenir-Book", size: 16)
        
        addSubview(label)
        
        return label
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
    
    // MARK: - Setup
    
    func setup() {
        isUserInteractionEnabled = false
    }
    
    // MARK: - LifeCycle
    
    override func layoutSubviews() {
            super.layoutSubviews()
            
            if !isAnimating() {
                label.frame = bounds
            }
        }
    
    // MARK: - Helper
    
    private func updateAnchorPoint(of view: UIView, textAlignment: NSTextAlignment) {
        
        switch (textAlignment, UIApplication.shared.userInterfaceLayoutDirection) {
        case (.natural, .leftToRight), (.justified, .leftToRight), (.left, _):
            view.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        
        case (.natural, .rightToLeft), (.justified, .rightToLeft), (.right, _):
            view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        
        case (.center, _):
            view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        @unknown default:
            // Use left-to-right value
            view.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        }
        
        view.frame = bounds
    }
    
    func scaleLabel(to scale: CGFloat, animated: Bool, duration: TimeInterval) {
            
        layoutIfNeeded()
        label.layer.removeAllAnimations()
        
        let transform = CATransform3DMakeScale(scale, scale, 1.0)
        
        if animated {
            let animation = CABasicAnimation(keyPath: "transform")
            let currentTransform = label.layer.presentation()?.transform ?? label.layer.transform
            animation.fromValue = currentTransform
            animation.toValue = transform
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.duration = duration
            label.layer.add(animation, forKey: scaleAnimationKey)
        }
        
        label.layer.transform = transform
    }
    
    private func isAnimating() -> Bool {
        
        return label.layer.animation(forKey: scaleAnimationKey) != nil
    }
}


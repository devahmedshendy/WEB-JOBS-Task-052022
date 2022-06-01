//
//  FormFieldUnderneathView.swift
//  Apollo
//
//  Created by Ahmed Shendy on 10/04/2022.
//

import UIKit

//@IBDesignable
class FormFieldUnderneathView: UIView {
    
    // MARK: - Theme
    
    let _hintFont: UIFont = UIFont(name: "Avenir-Book", size: 12)!
    
    // MARK: - Properties
    
    var hintText: String = "" {
        didSet {
            updateHintLabel()
        }
    }
    
    var hintColor: UIColor? {
        didSet {
            hintLabel.textColor = hintColor
        }
    }
    
    var underlineColor: UIColor? {
        didSet {
            gradientLayer.colors = [
                _authBackgroundColor.cgColor,
                underlineColor!.cgColor,
                _authBackgroundColor.cgColor
            ]
        }
    }
    
    var hintHorizontalOffset: CGFloat = 55 {
        didSet {
            // not working please fix
            guard hintText.isNotEmpty else  { return }
            
            hintLeadingConstraint.constant = hintHorizontalOffset
            layoutIfNeeded()
        }
    }
    
    private var hintLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Subviews/Sublayers
    
    private lazy var underlineView: UIView = UIView()
    private(set) lazy var hintLabel: UILabel = UILabel()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = underlineView.bounds

        layer.masksToBounds = true
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
        layer.colors = [
            _authBackgroundColor.cgColor,
            _formUnderlineMiddleColor.cgColor,
            _authBackgroundColor.cgColor
        ]
        layer.locations = [0, 0.5, 1]
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)

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
        
        gradientLayer.frame = underlineView.bounds
    }
    
    // MARK: - Setup
    
    private func setup() {
        // Add the Subviews
        addSubview(underlineView)
        
        // Setup the Subviews
        setupUnderlineView()
    }
    
    // MARK: - Helper
    
    private func updateHintLabel() {
        hintLabel.text = hintText
        hintLabel.isHidden = hintText.isEmpty
        
        if hintText.isEmpty {
            hintLabel.removeFromSuperview()
            
        } else {
            addSubview(hintLabel)
            setupHintLabel()
        }
    }
    
    // MARK: - Subviews Configurations
    
    private func setupUnderlineView() {
//        underlineView.backgroundColor = .white
        underlineView.layer.insertSublayer(gradientLayer, at: 0)
        
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupHintLabel() {
        hintLabel.isHidden = false
        hintLabel.font = _hintFont
        hintLabel.lineBreakMode = .byWordWrapping
        hintLabel.numberOfLines = 0
        
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        hintLeadingConstraint = hintLabel.leadingAnchor.constraint(equalTo: underlineView.leadingAnchor, constant: hintHorizontalOffset)
        
        NSLayoutConstraint.activate([
            hintLeadingConstraint,
            hintLabel.trailingAnchor.constraint(equalTo: underlineView.trailingAnchor),
            hintLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -2)
        ])
    }
}

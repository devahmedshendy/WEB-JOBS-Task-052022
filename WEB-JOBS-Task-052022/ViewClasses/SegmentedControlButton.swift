//
//  SegmentedControlButton.swift
//  Apollo
//
//  Created by Ahmed Shendy on 07/05/2022.
//

import UIKit

class SegmentedControlButton: UIButton {
    
    // MARK: - Theme
    
    private let _cornerRadius: CGFloat = 8
    private let selectedFont: UIFont = UIFont.systemFont(ofSize: 16)
    private let unSelectedFont: UIFont = UIFont.systemFont(ofSize: 16)
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel?.font = selectedFont
                backgroundColor = _segmentedTintColor
                
            } else {
                titleLabel?.font = unSelectedFont
                backgroundColor = .clear
            }
        }
    }
    
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
    
    private func setup() {
        clipsToBounds = true
        backgroundColor = .clear
//        layer.cornerRadius = _cornerRadius
        
        setTitleColor(_segmentedTintColor, for: .normal)
        setTitleColor(.white, for: .selected)
        
        isSelected = false
    }
    
}


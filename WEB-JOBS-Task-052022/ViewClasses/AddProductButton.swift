//
//  AddProductButton.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 02/06/2022.
//

import UIKit

class AddProductButton: UIButton {
    
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
        
        layer.cornerRadius = bounds.height / 2
    }
    
    // MARK: - Setup
    
    private func setup() {
        layer.borderWidth = 1
        layer.borderColor = _addProductBtnBorderColor.cgColor
    }
    
}

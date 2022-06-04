//
//  SortByFilterButton.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 04/06/2022.
//

import UIKit

class SortByFilterButton: UIButton {
    
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
    
    // MARK: - Setup
    
    private func setup() {
        layer.borderWidth = 1
        layer.borderColor = _addProductBtnBorderColor.cgColor
    }
    
}


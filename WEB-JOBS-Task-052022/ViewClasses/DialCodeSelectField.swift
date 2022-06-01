//
//  DialCodeSelectField.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 01/06/2022.
//

import UIKit

protocol DialCodeSelectFieldDelegate: AnyObject {
    func onDialCodeSelectTapped()
}

class DialCodeSelectField: FormSelectField {
    
    // MARK: - Properties
    
    weak var delegate: DialCodeSelectFieldDelegate?
    override var placeholder: String { "+0" }
    
    // MARK: - Setup

    override func setup() {
        super.setup()
        
        
        button.setTitle(placeholder, for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        icon.image = UIImage(systemName: "chevron.down")!.withTintColor(_formPlaceholderColor, renderingMode: .alwaysOriginal)
    }

    override func onSelectFieldTapped() {
        delegate?.onDialCodeSelectTapped()
    }
    
}

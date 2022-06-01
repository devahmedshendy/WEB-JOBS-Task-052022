//
//  NationalNumberField.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 01/06/2022.
//

import UIKit

protocol NationalNumberFieldDelegate: AnyObject {
    func onBecomeFirstResponder()
    func onResignFirstResponder()
}

class NationalNumberField: UITextField {
    
    weak var _delegate: NationalNumberFieldDelegate?
    
    // MARK: - inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    // MARK: - UIResponder
    
    open override func becomeFirstResponder() -> Bool {
        defer {
            _delegate?.onBecomeFirstResponder()
        }
        
        return super.becomeFirstResponder()
    }
    
    open override func resignFirstResponder() -> Bool {
        defer {
            _delegate?.onResignFirstResponder()
        }
        
        return super.resignFirstResponder()
    }
    
    // MARK: - Setup

    private func setup() {
        
        delegate = self
                
        placeholder = "Your number"
        keyboardType = .numberPad
        backgroundColor = .clear
        textColor = .white
        font = UIFont(name: "Avenir-Medium", size: 16)!
        
        borderStyle = .none
    }

}

extension NationalNumberField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return string.isEmpty
            || (string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil)
        
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        _delegate?.nationalNumberFieldShouldReturn(textField) ?? true
//    }
}

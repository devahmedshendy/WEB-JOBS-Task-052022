//
//  RegisterFormStackView.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 02/06/2022.
//

import UIKit

class RegisterFormStackView: UIStackView {
    
    // MARK: - Subviews
    
    private lazy var firstnameField: FormTextField = {
        arrangedSubviews[0] as! FormTextField
    }()
    
    private lazy var lastnameField: FormTextField = {
        arrangedSubviews[1] as! FormTextField
    }()
    
    private lazy var emailField: FormTextField = {
        arrangedSubviews[2] as! FormTextField
    }()
    
    private lazy var mobileField: FormMobileField = {
        arrangedSubviews[3] as! FormMobileField
    }()
    
    private lazy var passwordField: FormTextField = {
        arrangedSubviews[4] as! FormTextField
    }()
    
    private lazy var confirmPasswordField: FormTextField = {
        arrangedSubviews[5] as! FormTextField
    }()
    
    // MARK: - inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        firstnameField.delegate = self
        lastnameField.delegate = self
        emailField.delegate = self
        
    }
}

// MARK: - UITextFieldDelegate

extension RegisterFormStackView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case firstnameField:
            if lastnameField.text!.isEmpty {
                _ = lastnameField.becomeFirstResponder()
                return false
            }
            
        case lastnameField:
            if emailField.text!.isEmpty {
                _ = emailField.becomeFirstResponder()
                return false
            }
            
        case emailField:
            if mobileField.isEmpty {
                _ = mobileField.becomeFirstResponder()
                return false
            }
            
        case passwordField:
            if confirmPasswordField.text!.isEmpty {
                _ = confirmPasswordField.becomeFirstResponder()
                return false
            }
            
        default:
            textField.resignFirstResponder()
            return true
        }
        
        textField.resignFirstResponder()
        return true
    }
}

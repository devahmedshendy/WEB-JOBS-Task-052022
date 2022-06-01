//
//  FormPasswordField.swift
//  Apollo
//
//  Created by Ahmed Shendy on 10/04/2022.
//

import UIKit

//@IBDesignable
class FormPasswordField: FormTextField {
    
    // MARK: Handle 'Text is cleared when re-hiding"
    
    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        
        if isSecureTextEntry, let text = text {
            self.text?.removeAll()
            insertText(text)
        }
        
        return success
    }
    
    // MARK: - Subviews
    
    private lazy var revealButton: UIButton = UIButton()
    
    // MARK: - Setup
    
    override func setup() {
        super.setup()
        
        tintColor = _formPlaceholderColor
        
        setupRevealButton()
    }
    
    // MARK: - Subviews Configurations
    
    private func setupRevealButton() {
        
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        
        let openEye = UIImage(systemName: "eye", withConfiguration: config)!
            .withTintColor(_formPlaceholderColor, renderingMode: .alwaysTemplate)
        let closedEye = UIImage(systemName: "eye.slash", withConfiguration: config)!
            .withTintColor(_formPlaceholderColor, renderingMode: .alwaysTemplate)
        
        revealButton.setImage(openEye, for: .normal)
        revealButton.setImage(closedEye, for: .selected)
        
        revealButton.addTarget(
            self,
            action: #selector(toggleTextVisibility),
            for: .touchUpInside
        )

        rightView = revealButton
        rightViewMode = .always
    }
    
    @objc private func toggleTextVisibility() {
        isSecureTextEntry.toggle()
        revealButton.isSelected.toggle()
        _ = becomeFirstResponder()
    }
}


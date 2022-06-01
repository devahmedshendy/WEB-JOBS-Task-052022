//
//  FormMobileField.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 01/06/2022.
//

import UIKit

@IBDesignable
class FormMobileField: UIControl {
    
    // MARK: - Properties
    
    var isEmpty: Bool {
        return nationalNumberField.text?.isEmpty ?? true
    }
    
    // MARK: - Constraints
    
    private lazy var placeholderTopConstraint: NSLayoutConstraint! = {
        return placeholderView.topAnchor.constraint(equalTo: iconView.topAnchor)
    }()
    
    private lazy var placeholderCenterXConstraint: NSLayoutConstraint! = {
        return placeholderView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
    }()
    
    // MARK: - Subviews
    
    private lazy var iconView: UIImageView = UIImageView()
    private lazy var dialCodeField: DialCodeSelectField = DialCodeSelectField()
    private lazy var nationalNumberField: NationalNumberField = NationalNumberField()
    private lazy var placeholderContainerView: UIView = UIView()
    private lazy var placeholderView: FormFieldPlaceholderView = FormFieldPlaceholderView()
    private lazy var underneathView: FormFieldUnderneathView = FormFieldUnderneathView()
    
    private var placeholderLabel: UILabel {
        return placeholderView.label
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
    
    // MARK: - LifeCycle
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setup()
    }
    
    // MARK: - UIResponder
    
    open override func becomeFirstResponder() -> Bool {
        defer {
            print("Mobile Field: becomeFirstResponder")
            _ = nationalNumberField.becomeFirstResponder()
        }
        
        return super.becomeFirstResponder()
    }
    
    open override func resignFirstResponder() -> Bool {
        defer {
            print("Mobile Field: resignFirstResponder")
            _ = nationalNumberField.resignFirstResponder()
        }
        
        return super.resignFirstResponder()
    }
    
    // MARK: - Setup
    
    private func setup() {
        // Add the Subviews
        addSubview(iconView)
        addSubview(dialCodeField)
        addSubview(placeholderView)
        addSubview(nationalNumberField)
        addSubview(underneathView)
        
        // Setup the Subviews
        setupSelf()
        setupIconView()
        setupPlaceholderView()
        setupDialCodeField()
        setupNationalNumberField()
        setupUnderneathView()
        
        nationalNumberField._delegate = self
        
        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(selfTapped)
            )
        )
    }
    
    // MARK: - Actions
    
    @objc private func selfTapped() {
        _ = becomeFirstResponder()
    }
    
    // MARK: - Subviews Configurations
    
    private func setupSelf() {
        backgroundColor = .clear
    }
    
    private func setupIconView() {
        iconView.image = UIImage(named: "icon_phone")
        iconView.contentMode = .scaleAspectFit
        
        // Constraints Configuration
        iconView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            iconView.topAnchor.constraint(equalTo: self.topAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)
        ])
    }
    
    private func setupPlaceholderView() {
        placeholderLabel.text = "MOBILE"
        placeholderView.textAlignment = .natural
        
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints Configuration
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        
//        let centerX = placeholderView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
//        centerX.priority = .fittingSizeLevel
        
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 30),
            placeholderCenterXConstraint
        ])
    }
    
    private func setupDialCodeField() {
        dialCodeField.isHidden = true
        
        // Constraints Configuration
        dialCodeField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dialCodeField.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 30),
            dialCodeField.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setupNationalNumberField() {
        nationalNumberField.isHidden = true
        
        // Constraints Configuration
        nationalNumberField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nationalNumberField.leadingAnchor.constraint(equalTo: dialCodeField.trailingAnchor, constant: 30),
            nationalNumberField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nationalNumberField.centerYAnchor.constraint(equalTo: dialCodeField.centerYAnchor)
        ])
    }
    
    private func setupUnderneathView() {
        
        // Constraints Configuration
        underneathView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            underneathView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            underneathView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            underneathView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

// MARK: - NationalNumberFieldDelegate

extension FormMobileField: NationalNumberFieldDelegate {
    
    func onBecomeFirstResponder() {
        underneathView.underlineColor = .white
        
        placeholderTopConstraint.isActive.toggle()
        placeholderCenterXConstraint.isActive.toggle()
        
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.layoutIfNeeded()
            },
            completion: { _ in
                self.dialCodeField.isHidden = false
                self.nationalNumberField.isHidden = false
            }
        )
    }
    
    func onResignFirstResponder() {
        underneathView.underlineColor = _formUnderlineMiddleColor
        
        guard isEmpty else { return }
        
        dialCodeField.isHidden = true
        nationalNumberField.isHidden = true
        
        placeholderTopConstraint.isActive.toggle()
        placeholderCenterXConstraint.isActive.toggle()
        
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.layoutIfNeeded()
            }
        )
    }
    
    private func animatePlaceholder() {
        
    }
    
//    func nationalNumberFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return true
//    }
    
    
}

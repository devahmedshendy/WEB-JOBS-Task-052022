//
//  FormSelectField.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 01/06/2022.
//

import UIKit

class FormSelectField: UIView {
    
    // MARK: - Properties
    
    var placeholder: String { "Select" }
    var selectedOption: String = ""
    
    // MARK: - Subviews
    
    var button: UIButton!
    var icon: UIImageView!
    
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
        // Create the Subviews
        button = UIButton()
        icon = UIImageView()
        
        // Add the Subviews
        addSubview(button)
        addSubview(icon)
        
        // Setup the Subviews
        setupButton()
        setupIcon()
        
        
        setupActions()
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        button.addTarget(
            self,
            action: #selector(onSelectFieldTapped),
            for: .touchUpInside
        )
    }
    
    // MARK: - Subviews Configurations
    
    private func setupButton() {
        button.backgroundColor = .clear
        button.setTitle(placeholder, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 16)!
        button.titleLabel?.textAlignment = .natural
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.setTitleColor(_formPlaceholderColor, for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.contentHorizontalAlignment = .leading
//        var configuration = UIButton.Configuration.plain()
//        configuration.imagePadding = 15
//
//        button.configuration = configuration
        button.contentEdgeInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 50
        )
        
        // Constraints Configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupIcon() {
        icon.image = UIImage(systemName: "chevron.down")!.withTintColor(_formPlaceholderColor, renderingMode: .alwaysOriginal)
        
        // Constraints Configuration
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            icon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            icon.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }
    
    // MARK: - Helpers
    
    func setSelectedOption(_ selection: String) {
        selectedOption = selection
        button.setTitle(selectedOption, for: .selected)
        button.isSelected = true
    }
    
    func reset() {
        selectedOption = ""
        button.setTitle(placeholder, for: .normal)
        button.isSelected = false
    }
    
    // MARK: - FormSelectFieldTappable
    
    @objc func onSelectFieldTapped() {
        // To be implemented by subclass views
    }
}

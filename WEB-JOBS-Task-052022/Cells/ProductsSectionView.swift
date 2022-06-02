//
//  ProductsSectionView.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 02/06/2022.
//

import UIKit

class ProductsSectionView: UICollectionReusableView {
    
    static let reuseIdentifier = String(describing: ProductsSectionView.self)
    
    static var nib: UINib {
        return UINib(nibName: String(describing: ProductsSectionView.self), bundle: nil)
    }
    
    // MARK: - Properties
    
    var name: String = "Section Name" {
        didSet {
            nameLabel.text = name
        }
    }
    
    // MARK: - Subviews
    
    private let nameLabel: UILabel = UILabel()
    
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

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    // MARK: - Setup

    private func setup() {
        
        // Add the Subviews
        addSubview(nameLabel)
        
        // Setup the Subviews
        setupSelf()
        setupNameLabel()
    }
    
    // MARK: - Subviews Configurations
    
    private func setupSelf() {
        backgroundColor = .white
    }
    
    private func setupNameLabel() {
        nameLabel.text = name
        nameLabel.numberOfLines = 1
        nameLabel.textColor = _productsSectionNameColor
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "Avenir-Medium", size: 22)!
        
        // Constraint Configuration
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = nameLabel.leadingAnchor
            .constraint(equalTo: self.leadingAnchor,
                        constant: 20)
        let trailing = nameLabel.trailingAnchor
            .constraint(equalTo: self.trailingAnchor,
                        constant: -20)
        let centerY = nameLabel.centerYAnchor
            .constraint(equalTo: self.centerYAnchor)
        
        NSLayoutConstraint.activate([
            leading, trailing,
            centerY
        ])
    }
    
}

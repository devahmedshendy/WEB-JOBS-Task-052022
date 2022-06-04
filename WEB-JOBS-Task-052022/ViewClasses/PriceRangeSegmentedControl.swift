//
//  PriceRangeSegmentedControl.swift
//  Apollo
//
//  Created by Ahmed Shendy on 07/05/2022.
//

import UIKit

enum PriceRangeSegment: String {
    case priceOfStay = "Price of stay"
    case pricePerNight = "Price per night"
}

class PriceRangeSegmentedControl: UIControl {
    
    // MARK: - Theme
    private let _cornerRadius: CGFloat = 5
    
    // MARK: - Properties
    
    var selectedSegment: PriceRangeSegment = .priceOfStay {
        didSet {
            priceOfStayButton.isSelected = selectedSegment == .priceOfStay
            pricePerNightButton.isSelected = selectedSegment == .pricePerNight
            
            sendActions(for: .valueChanged)
        }
    }
    
    // MARK: - Subviews
    
    private lazy var priceOfStayButton: SegmentedControlButton = {
        subviews.first(where: { $0.tag == 0 }) as! SegmentedControlButton
    }()
    
    private lazy var pricePerNightButton: SegmentedControlButton = {
        subviews.first(where: { $0.tag == 1 }) as! SegmentedControlButton
    }()
    
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
        setupSelf()
        
        setupActions()
        
        selectedSegment = .priceOfStay
    }
    
    private func setupSelf() {
        clipsToBounds = true
        
        backgroundColor = .clear
        
        layer.masksToBounds = true
        layer.cornerRadius = _cornerRadius
        layer.borderWidth = 2
        layer.borderColor = _segmentedTintColor.cgColor
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        priceOfStayButton.addTarget(
            self,
            action: #selector(ridesHistoryTapped),
            for: .touchUpInside
        )
        
        pricePerNightButton.addTarget(
            self,
            action: #selector(statisticsTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func ridesHistoryTapped() {
        selectedSegment = .priceOfStay
    }
    
    @objc private func statisticsTapped() {
        selectedSegment = .pricePerNight
    }
}

//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by Ahmed Shendy on 03/06/2022.
//

import UIKit

//@IBDesignable
class RangeSlider: UIControl {
    
    // MARK: - Properties
    
    private let trackHeight: CGFloat = 2.0
    private let thumbSizeFactor: CGFloat = 15
    
    let minValue: Int = 10
    let maxValue: Int = 500
    private lazy var midValue: Int = {
        return ((maxValue - minValue) / 2) + minValue
    }()

    var lowValue: Int = 10 {
        didSet {
            onLowValueChanged()
            sendActions(for: .valueChanged)
        }
    }
    
    var highValue: Int = 500 {
        didSet {
            onHighValueChanged()
            sendActions(for: .valueChanged)
        }
    }
    
    private lazy var pointsCount = ((maxValue - minValue) / 5) + 1

    private var pointsSpacing: CGFloat {
        let minPosition = bounds.midY
        let maxPosition = bounds.maxX - minPosition

        return (maxPosition
         - minPosition) / CGFloat(pointsCount - 1)
    }
    
    override var bounds: CGRect {
        didSet {
            onBoundsChanged()
        }
    }
    
    // MARK: - Sublayers
    
    private lazy var rangeLayer: RangeLayer = RangeLayer()
    private lazy var trackLayer: TrackLayer = TrackLayer()
    private lazy var lowThumb: ThumbView = ThumbView()
    private lazy var highThumb: ThumbView = ThumbView()
    
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
    
    // MARK: - Setup
    
    private func setup() {
        layer.insertSublayer(trackLayer, at: 0)
        layer.addSublayer(rangeLayer)
        addSubview(lowThumb)
        addSubview(highThumb)
        
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        heightAnchor.constraint(equalToConstant: trackHeight * thumbSizeFactor).isActive = true
        
        setupActions()
    }
    
    // MARK: - Actions
    
    private func setupActions() {
        lowThumb.addGestureRecognizer(
            UIPanGestureRecognizer(
                target: self,
                action: #selector(onPositionChangedForLowThumb)
            )
        )
        
        highThumb.addGestureRecognizer(
            UIPanGestureRecognizer(
                target: self,
                action: #selector(onPositionChangedForHighThumb)
            )
        )
    }
    
    @objc private func onPositionChangedForLowThumb(_ recognizer: UIPanGestureRecognizer)  {
        let newPosition = recognizer.location(in: self)
        let newValue = valueForPosition(newPosition)
        
        if newValue < highValue {
            lowValue = newValue
        }
    }
    
    @objc private func onPositionChangedForHighThumb(_ recognizer: UIPanGestureRecognizer)  {
        let newPosition = recognizer.location(in: self)
        let newValue = valueForPosition(newPosition)
        
        if newValue > lowValue {
            highValue = newValue
        }
    }
    
    // MARK: - Helpers
    
    private func onBoundsChanged() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
                
        
        let minLocation = positionForValue(minValue)
        let maxLocation = positionForValue(maxValue)

        trackLayer.frame = CGRect(
            x: minLocation.x,
            y:  bounds.midY - (trackHeight/2),
            width: maxLocation.x - minLocation.x,
            height: trackHeight
        )
        trackLayer.setNeedsDisplay()
        
        let lowLocation = positionForValue(lowValue)
        let highLocation = positionForValue(highValue)
        
        rangeLayer.frame = CGRect(
            x: lowLocation.x,
            y: bounds.midY - (trackHeight/2),
            width: highLocation.x - lowLocation.x,
            height: trackHeight
        )
        rangeLayer.minX = lowLocation.x
        rangeLayer.maxX = highLocation.x
        rangeLayer.setNeedsDisplay()
        
        lowThumb.frame = CGRect(
            x: 0,
            y: 0,
            width: trackHeight * thumbSizeFactor,
            height: trackHeight * thumbSizeFactor
        )
        lowThumb.layer.position = CGPoint(
            x: lowLocation.x,
            y: lowLocation.y
        )
        lowThumb.layer.cornerRadius = lowThumb.frame.height / 2
        lowThumb.setNeedsDisplay()
        
        highThumb.frame = CGRect(
            x: 0,
            y: 0,
            width: trackHeight * thumbSizeFactor,
            height: trackHeight * thumbSizeFactor
        )
        highThumb.layer.position = CGPoint(
            x: highLocation.x,
            y: highLocation.y
        )
        highThumb.layer.cornerRadius = highThumb.frame.height / 2
        highThumb.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    private func onLowValueChanged() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let location = positionForValue(lowValue)
        
        rangeLayer.minX = location.x
        rangeLayer.setNeedsDisplay()
        
        lowThumb.layer.position = CGPoint(
            x: location.x,
            y: location.y
        )
        lowThumb.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    private func onHighValueChanged() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let location = positionForValue(highValue)
        
        rangeLayer.maxX = location.x
        rangeLayer.setNeedsDisplay()
        
        highThumb.layer.position = CGPoint(
            x: location.x,
            y: location.y
        )
        highThumb.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    private func positionForValue(_ value: Int) -> CGPoint {
        let index = indexForValue(value)
        let padding = bounds.midY
        
        return CGPoint(
            x: padding + (pointsSpacing * CGFloat(index)),
            y: padding
        )
    }
    
    private func indexForValue(_ value: Int) -> Int {
        return (value - minValue) / 5
    }
    
    private func valueForPosition(_ position: CGPoint) -> Int {
        
        let minPosition = bounds.midY
        if position.x <= minPosition {
            return minValue
        }
        
        let maxPosition = bounds.maxX - minPosition
        if position.x >= maxPosition {
            return maxValue
        }
        
        let positionIndex = indexForPosition(position)

        return positionIndex * 5 + minValue
    }
    
    private func indexForPosition(_ position: CGPoint) -> Int {
        let minPosition = bounds.minX + bounds.midY
        return Int(round((position.x - minPosition) / pointsSpacing))
    }
}

fileprivate class RangeLayer: CALayer {
    
    // MARK: - Properties
    
    private let color: CGColor = _sliderRangeColor.cgColor
    
    var minX: CGFloat = 0 {
        didSet {
            updateFrame()
        }
    }
    var maxX: CGFloat = 0 {
        didSet {
            updateFrame()
        }
    }
    
    private func updateFrame() {
        frame = CGRect(
            x: minX,
            y: frame.minY,
            width: maxX - minX,
            height: frame.height
        )
    }
    
    // MARK: - inits
    
    override init() {
        super.init()
        
        setup()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        
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
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        cornerRadius = bounds.height / 2
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = color
    }
}

fileprivate class TrackLayer: CALayer {
    
    // MARK: - inits
    
    override init() {
        super.init()
        
        setup()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        
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
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        cornerRadius = bounds.height / 2
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    }
}

fileprivate class ThumbView: UIView {
    
    // MARK: - Properties
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 2
    }
    
    // MARK: - Setup
    
    private func setup() {
        clipsToBounds = false
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
        backgroundColor = UIColor.white

        layer.shadowColor = UIColor.black.withAlphaComponent(0.16).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6.0 / 2.0
        layer.shadowOpacity = 1
        
        layer.shouldRasterize = true
//        rasterizationScale = .
    }
}

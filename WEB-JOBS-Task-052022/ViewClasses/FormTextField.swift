//
//  FormTextField.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 31/05/2022.
//

import UIKit

let overlaySpaceToText: CGFloat = 10.0
let defaultPlaceholderAnimationDuration = CFTimeInterval(0.2)

@IBDesignable
class FormTextField: UITextField {
    
    private enum HorizontalPosition {
        case left, right
    }
    
    private final class PlaceholderConstraints {
        
        var normalX: NSLayoutConstraint?
        var normalY: NSLayoutConstraint?
        var scaledX: NSLayoutConstraint?
        var scaledY: NSLayoutConstraint?
        
        func clearHorizontalConstraints() {
            
            normalX?.isActive = false
            normalX = nil
            scaledX?.isActive = false
            scaledX = nil
        }
    }
    
    // MARK: - Theme
    
    private var _contentTopInset: CGFloat { 13 }
    private var _contentBottomInset: CGFloat { 13 }
    private var _contentLeftInset: CGFloat { 14 }
    private var _contentRightInset: CGFloat { 14 }
    
    private var _contentInsets: UIEdgeInsets {
        UIEdgeInsets(top: _contentTopInset,
                     left: 0,
                     bottom: _contentBottomInset,
                     right: 0)
    }
    
    private var transformedPlaceholderColor: UIColor = .white {
        didSet {
            updateUnderlineColor()
        }
    }
    
    private var _textFont: UIFont = UIFont(name: "Avenir-Medium", size: 16)!
    
    // MARK: - Inspectables
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            let imageView = UIImageView(image: leftImage)
            imageView.contentMode = .scaleAspectFit

            leftView = imageView
            leftViewMode = .always
        }
    }
    
    // MARK: - Properties
    
    var helpText: String = "" {
        didSet {
            updateHintLabel()
        }
    }
    
    var feedbackText: String = "" {
        didSet {
            updateHintLabel()
        }
    }
    
    var isPlaceholderTransformedToScaledPosition = false
    
    private var needsUpdateOfHorizontalPlaceholderConstraints = false
    private var needsUpdateOfVerticalPlaceholderConstraints = false
    
    private var underneathOffset: CGFloat = 42.0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    private var placeholderMode: FormFieldPlaceholderMode = .scalesWhenEditing {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsUpdateVerticalPlaceholderConstraints()
            updatePlaceholderTransform()
            updateUnderlineColor()
        }
    }
    
    private var placeholderScaleWhenEditing: CGFloat = 1 {
        didSet {
            placeholderScaleWhenEditing = max(0.0, placeholderScaleWhenEditing)
            
            invalidateIntrinsicContentSize()
            setNeedsUpdateVerticalPlaceholderConstraints()
        }
    }
    
    private var scaledPlaceholderOffset: CGFloat = -16.0
    
    private let placeholderConstraints = PlaceholderConstraints()
    
    private var userInterfaceDirectionAwareTextPadding: UIEdgeInsets {
        
        if UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
            return textPadding
        }
        
        var padding = textPadding
        swap(&padding.left, &padding.right)
        
        return padding
    }
    
    /// The computed height of the untransformed placeholder in points.
    private var placeholderHeight: CGFloat {
        
        return measureTextHeight(using: placeholderLabel.font)
    }
    
    private var textPadding: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsUpdatePlaceholderConstraints()
        }
    }
    
    private var textPaddingMode: FormFieldTextPaddingMode = .text {
        didSet {
            setNeedsLayout()
            setNeedsUpdatePlaceholderConstraints()
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            underneathView.hintLabel.textAlignment = textAlignment
            placeholderView.textAlignment = textAlignment
            
            placeholderConstraints.clearHorizontalConstraints()
            setNeedsUpdateConstraints()
        }
    }
    
    override var text: String? {
        didSet {
            setNeedsUpdateHorizontalPlaceholderConstraints()
            updatePlaceholderTransform()
            updateUnderlineColor()
        }
    }
    
    override var placeholder: String? {
        set {
            placeholderLabel.text = newValue
            placeholderView.invalidateIntrinsicContentSize()
        }
        get {
            return placeholderLabel.text
        }
    }
    
    override var intrinsicContentSize: CGSize {
        
        let height = ceil(computeTopInsetToText() + measureTextHeight() + computeBottomInsetToText())
        let size = CGSize(width: intrinsicWidth(), height: height)
        
        return size
    }
    
    
    // MARK: - Subviews
    
    private lazy var placeholderContainerView: UIView = UIView()
    private lazy var placeholderView: FormFieldPlaceholderView = FormFieldPlaceholderView()
    private lazy var underneathView: FormFieldUnderneathView = FormFieldUnderneathView()
    
    private var placeholderLabel: UILabel {
        return placeholderView.label
    }
    
    // MARK: Overlay views
    
    open override var leftView: UIView? {
        didSet {
            setNeedsUpdateHorizontalPlaceholderConstraints()
        }
    }
    
    open override var leftViewMode: UITextField.ViewMode {
        didSet {
            setNeedsUpdateHorizontalPlaceholderConstraints()
        }
    }
    
    private var leftViewPosition: HorizontalPosition {
        
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            return .right
        } else {
            return .left
        }
    }
    
    private var isLeftViewVisible: Bool {
        
        guard leftView != nil else { return false }
        return isOverlayVisible(with: leftViewMode)
    }
    
    open override var rightView: UIView? {
        didSet {
            setNeedsUpdateHorizontalPlaceholderConstraints()
        }
    }
    
    open override var rightViewMode: UITextField.ViewMode {
        didSet {
            setNeedsUpdateHorizontalPlaceholderConstraints()
        }
    }
    
    private var rightViewPosition: HorizontalPosition {
        
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            return .left
        } else {
            return .right
        }
    }
    
    private var isRightViewVisible: Bool {
        
        guard rightView != nil else { return false }
        return isOverlayVisible(with: rightViewMode)
    }
    
    private func isOverlayVisible(with viewMode: UITextField.ViewMode) -> Bool {
        
        switch viewMode {
        case .always:
            return true
        case .whileEditing:
            return isEditing
        case .unlessEditing:
            return !isEditing || !hasText
        case .never:
            return false
        @unknown default:
            return false
        }
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Copy the placeholder from the super class and set it nil
        if let superPlaceholder = super.placeholder {
            // Use the super placeholder only if the placeholder label has no text yet
            if placeholderLabel.text == nil {
                placeholder = superPlaceholder
            }
            
            super.placeholder = nil
        }
    }
    
    // MARK: - Update Constraints
    
    override func updateConstraints() {
        if placeholderConstraints.normalX == nil {
            placeholderConstraints.normalX = makeNormalHorizontalPlaceholderConstraint(textAlignment: textAlignment)
            placeholderConstraints.normalX?.isActive = !isPlaceholderTransformedToScaledPosition
        } else if needsUpdateOfHorizontalPlaceholderConstraints {
            let horizontalOffset = normalHorizontalPlaceholderConstraintConstant(for: textAlignment)
            placeholderConstraints.normalX?.constant = horizontalOffset
            placeholderConstraints.normalX?.isActive = !isPlaceholderTransformedToScaledPosition
            
            underneathView.hintHorizontalOffset = horizontalOffset
        }
        
        if placeholderConstraints.normalY == nil {
            placeholderConstraints.normalY = makeNormalVerticalPlaceholderConstraint()
            placeholderConstraints.normalY?.isActive = !isPlaceholderTransformedToScaledPosition
        } else if needsUpdateOfVerticalPlaceholderConstraints {
            placeholderConstraints.normalY?.constant = normalVerticalPlaceholderConstraintConstant()
            placeholderConstraints.normalY?.isActive = !isPlaceholderTransformedToScaledPosition
        }
        
        if placeholderConstraints.scaledX == nil {
            placeholderConstraints.scaledX = makeScaledHorizontalPlaceholderConstraint(textAlignment: textAlignment)
            placeholderConstraints.scaledX?.isActive = isPlaceholderTransformedToScaledPosition
        } else if needsUpdateOfHorizontalPlaceholderConstraints {
            placeholderConstraints.scaledX?.constant = scaledHorizontalPlaceholderConstraintConstant(for: textAlignment)
            placeholderConstraints.scaledX?.isActive = isPlaceholderTransformedToScaledPosition
        }
        
        if placeholderConstraints.scaledY == nil {
            placeholderConstraints.scaledY = makeScaledVerticalPlaceholderConstraint()
            placeholderConstraints.scaledY?.isActive = isPlaceholderTransformedToScaledPosition
        } else if needsUpdateOfVerticalPlaceholderConstraints {
            placeholderConstraints.scaledY?.constant = scaledVerticalPlaceholderConstraintConstant()
            placeholderConstraints.scaledY?.isActive = isPlaceholderTransformedToScaledPosition
        }
        
        needsUpdateOfHorizontalPlaceholderConstraints = false
        needsUpdateOfVerticalPlaceholderConstraints = false
        
        super.updateConstraints()
    }
    
    // MARK: - UIResponder
    
    open override func becomeFirstResponder() -> Bool {
        defer {
            updatePlaceholderTransform(animated: true)
            updateUnderlineColor()
        }
        
        return super.becomeFirstResponder()
    }
    
    open override func resignFirstResponder() -> Bool {
        defer {
            updatePlaceholderTransform(animated: true)
            clearUnderlineColor()
        }
        
        return super.resignFirstResponder()
    }
    
    // MARK: - Field Insets
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return textAndEditingRect(forBounds: bounds).offsetBy(dx: 15, dy: 20)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return textAndEditingRect(forBounds: bounds) .offsetBy(dx: 15, dy: 20)
    }
    
    private func textAndEditingRect(forBounds bounds: CGRect) -> CGRect {
        
        let leftInset = computeLeftInsetToText()
        let rightInset = computeRightInsetToText() + 15
        let topInset = computeTopInsetToText()
        let bottomInset = computeBottomInsetToText()
        
        let insets = UIEdgeInsets(
            top: topInset,
            left: leftInset,
            bottom: bottomInset,
            right: rightInset
        )
        let rect = bounds.inset(by: insets)
        
        return rect
    }
    
    open override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        
        let superValue = super.leftViewRect(forBounds: bounds)
        let size = superValue.size
        let x = userInterfaceDirectionAwareTextPadding.left
        let y = computeTopInsetToText() + 0.5 * (measureTextHeight() - size.height)
        let rect = CGRect(origin: CGPoint(x: x, y: y), size: size)
        
        return rect.insetBy(dx: 10, dy: 10).offsetBy(dx: -10, dy: 0)
    }
    
    open override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        let superValue = super.rightViewRect(forBounds: bounds)
        let size = superValue.size
        let x = bounds.width - userInterfaceDirectionAwareTextPadding.right - size.width
        let y = computeTopInsetToText() + 0.5 * (measureTextHeight() - size.height)
        let rect = CGRect(origin: CGPoint(x: x, y: y), size: size)
        
        return rect
    }
    
    // MARK: - Setup
    
    func setup() {
//        autocapitalizationType = .none
        backgroundColor = .clear
        textColor = .white
        font = _textFont
        
        borderStyle = .none
        
        placeholderContainerView = UIView()
        addSubview(placeholderContainerView)
        setupPlaceholderContainerView()
        
        placeholderContainerView.addSubview(placeholderView)
        setupPlaceholderView()
        
        addSubview(underneathView)
        setupUnderneathView()
        
        // Listen for text changes on self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextField.textDidChangeNotification,
            object: self
        )
        
    }
    
    @objc private func textDidChange() {
        updatePlaceholderTransform(animated: true)
        updateUnderlineColor()
    }
    
    // MARK: - Helper
    
    private func updateHintLabel() {

        if feedbackText.isNotEmpty {
            underneathView.hintText = feedbackText
            underneathView.hintColor = _dangerColor
            
        } else if helpText.isNotEmpty {
            underneathView.hintText = helpText
            underneathView.hintColor = _formPlaceholderColor.withAlphaComponent(0.75)
        
        } else {
            underneathView.hintText = ""
        }
        
        invalidateIntrinsicContentSize()
    }
    
    /// Measures the height of the given text using the given font.
    ///
    /// - Parameters:
    ///   - font: The font to use
    ///   - text: The text whose height is measured, "X" is The string used to measure the height of an arbitrary string
    /// - Returns: The height of the given string
    private func measureTextHeight(text: String = "X", using font: UIFont? = nil) -> CGFloat {
        
        guard let font = font ?? self.font else { return 0.0 }
        let boundingSize = text.size(using: font)
        
        return boundingSize.height
    }
    
    private func intrinsicWidth() -> CGFloat {
        
        let textWidth = (text ?? "").size(using: font!).width
        let placeholderWidth = (placeholder ?? "").size(using: placeholderLabel.font).width
        let width = computeLeftInsetToText() + max(textWidth, placeholderWidth) + computeRightInsetToText()
        
        return ceil(width)
    }
    
    // MARK: - Animations
    
    private func updatePlaceholderTransform(animated: Bool = false) {
        
        var updated = false
        let duration = defaultPlaceholderAnimationDuration
        
        switch (shouldDisplayScaledPlaceholder(), isPlaceholderTransformedToScaledPosition) {
        case (true, false):
            placeholderView.scaleLabel(to: placeholderScaleWhenEditing, animated: animated, duration: duration)
            isPlaceholderTransformedToScaledPosition = true
            updated = true
        
        case (false, true):
            placeholderView.scaleLabel(to: 1.0, animated: animated, duration: duration)
            isPlaceholderTransformedToScaledPosition = false
            updated = true
        
        default:
            break
        }
        
        if updated {
            if animated {
                animatePlaceholder(scaled: isPlaceholderTransformedToScaledPosition, duration: duration)
            } else {
                updatePlaceholderConstraints(scaled: isPlaceholderTransformedToScaledPosition)
            }
        }
        
        // Update the general visibility of the placeholder
        if shouldDisplayPlaceholder() != !placeholderView.isHidden {
            placeholderView.isHidden.toggle()
        }
    }
    
    private func animatePlaceholder(scaled: Bool, duration: TimeInterval) {
        
        UIView.animate(withDuration: duration) { [unowned self] in
            self.updatePlaceholderConstraints(scaled: scaled)
            self.placeholderContainerView.layoutIfNeeded()
        }
    }
    
    private func updatePlaceholderConstraints(scaled: Bool) {
        
        // Note: Deactivate first, then activate. Otherwise, Auto Layout complains about unsatisfiable constraints.
        if scaled {
            placeholderConstraints.normalX?.isActive = false
            placeholderConstraints.normalY?.isActive = false
            placeholderConstraints.scaledX?.isActive = true
            placeholderConstraints.scaledY?.isActive = true
        } else {
            placeholderConstraints.scaledX?.isActive = false
            placeholderConstraints.scaledY?.isActive = false
            placeholderConstraints.normalX?.isActive = true
            placeholderConstraints.normalY?.isActive = true
        }
    }
    
    private func shouldDisplayScaledPlaceholder() -> Bool {
        let result: Bool
        
        switch placeholderMode {
        case .scalesWhenEditing:
            result = (text != nil) && !text!.isEmpty || isFirstResponder
        
        case .scalesAlways:
            result = true
        
        default:
            result = false
        }
        
        return result
    }
    
    private func shouldDisplayPlaceholder() -> Bool {
        let result: Bool
        
        switch placeholderMode {
        case .scalesWhenEditing:
            result = true
        
        case .scalesAlways:
            result = true
        
        case .simple:
            result = (text == nil) || text!.isEmpty
        }
        
        return result
    }
    
    func updateUnderlineColor() {
        let newUnderlineColor: UIColor?
        
        if isPlaceholderTransformedToScaledPosition {
            newUnderlineColor = .white
            
        } else {
            newUnderlineColor = _formUnderlineMiddleColor
        }
        
        if newUnderlineColor != underneathView.underlineColor {
            underneathView.underlineColor = newUnderlineColor
        }
    }
    
    func clearUnderlineColor() {
        underneathView.underlineColor = _formUnderlineMiddleColor
    }
    
    // MARK: - Constraints
    
    private func setNeedsUpdateHorizontalPlaceholderConstraints() {
        
        needsUpdateOfHorizontalPlaceholderConstraints = true
        setNeedsUpdateConstraints()
    }
    
    private func setNeedsUpdateVerticalPlaceholderConstraints() {
        
        needsUpdateOfVerticalPlaceholderConstraints = true
        setNeedsUpdateConstraints()
    }
    
    private func setNeedsUpdatePlaceholderConstraints() {
        
        needsUpdateOfHorizontalPlaceholderConstraints = true
        needsUpdateOfVerticalPlaceholderConstraints = true
        setNeedsUpdateConstraints()
    }
    
    private func makeNormalHorizontalPlaceholderConstraint(textAlignment: NSTextAlignment) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        
        switch (textAlignment, UIApplication.shared.userInterfaceLayoutDirection) {
        case (.left, .leftToRight), (.right, .rightToLeft), (.justified, _), (.natural, _):
            constraint = placeholderView.leadingAnchor.constraint(equalTo: placeholderContainerView.leadingAnchor)
        
        case (.left, .rightToLeft), (.right, .leftToRight):
            constraint = placeholderContainerView.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor)
        
        case (.center, _):
            constraint = placeholderView.centerXAnchor.constraint(equalTo: placeholderContainerView.centerXAnchor)
        
        @unknown default:
            // Use left-to-right constraint
            constraint = placeholderView.leadingAnchor.constraint(equalTo: placeholderContainerView.leadingAnchor)
        }
        
        constraint.constant = normalHorizontalPlaceholderConstraintConstant(for: textAlignment)
        
        return constraint
    }
    
    private func normalHorizontalPlaceholderConstraintConstant(for textAlignment: NSTextAlignment) -> CGFloat {
        let additionalInset: CGFloat = 15
        
        switch (textAlignment, UIApplication.shared.userInterfaceLayoutDirection) {
        case (.natural, .leftToRight), (.justified, .leftToRight), (.left, _):
            return computeLeftInsetToText() + additionalInset
            
        case (.natural, .rightToLeft), (.justified, .rightToLeft), (.right, _):
            return computeRightInsetToText() + additionalInset
            
        case (.center, _):
            return 0.0
            
        @unknown default:
            // Use left-to-right value
            return computeLeftInsetToText() + additionalInset
        }
    }
    
    private func makeNormalVerticalPlaceholderConstraint() -> NSLayoutConstraint {
        
        let constraint = placeholderView.centerYAnchor.constraint(equalTo: placeholderContainerView.topAnchor)
        constraint.constant = normalVerticalPlaceholderConstraintConstant()
        
        return constraint
    }
    
    private func normalVerticalPlaceholderConstraintConstant() -> CGFloat {
        
        return computeTopInsetToText() + 0.5 * measureTextHeight()
    }
    
    private func makeScaledHorizontalPlaceholderConstraint(textAlignment: NSTextAlignment) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        
        switch (textAlignment, UIApplication.shared.userInterfaceLayoutDirection) {
        case (.left, .leftToRight), (.right, .rightToLeft), (.justified, _), (.natural, _):
            constraint = placeholderView.leadingAnchor.constraint(equalTo: placeholderContainerView.leadingAnchor)
        
        case (.left, .rightToLeft), (.right, .leftToRight):
            constraint = placeholderContainerView.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor)
        
        case (.center, _):
            constraint = placeholderView.centerXAnchor.constraint(equalTo: placeholderContainerView.centerXAnchor)
        
        @unknown default:
            // Use left-to-right constraint
            constraint = placeholderView.leadingAnchor.constraint(equalTo: placeholderContainerView.leadingAnchor)
        }
        
        constraint.constant = scaledHorizontalPlaceholderConstraintConstant(for: textAlignment)
        
        return constraint
    }
    
    private func scaledHorizontalPlaceholderConstraintConstant(for textAlignment: NSTextAlignment) -> CGFloat {
        let additionalInset: CGFloat = 15
//        return (textAlignment == .center) ? 0.0 : textPadding.left
        switch (textAlignment, UIApplication.shared.userInterfaceLayoutDirection) {
        case (.natural, .leftToRight), (.justified, .leftToRight), (.left, _):
            return computeLeftInsetToText() + additionalInset
            
        case (.natural, .rightToLeft), (.justified, .rightToLeft), (.right, _):
            return computeRightInsetToText() + additionalInset
            
        case (.center, _):
            return 0.0
            
        @unknown default:
            // Use left-to-right value
            return computeLeftInsetToText() + additionalInset
        }
    }
    
    private func makeScaledVerticalPlaceholderConstraint() -> NSLayoutConstraint {
        
        let constraint = placeholderView.centerYAnchor.constraint(equalTo: placeholderContainerView.topAnchor)
        constraint.constant = scaledVerticalPlaceholderConstraintConstant()
        
        return constraint
    }
    
    private func scaledVerticalPlaceholderConstraintConstant() -> CGFloat {
        
        let additionalTopInset = [
            FormFieldTextPaddingMode.textAndPlaceholder,
            FormFieldTextPaddingMode.textAndPlaceholderAndHint
        ].contains(textPaddingMode) ? textPadding.top : 0.0
        let scaledHeight = placeholderScaleWhenEditing * measureTextHeight(using: placeholderLabel.font)
        return computeTopInsetToText() - textPadding.top - scaledPlaceholderOffset - 0.5 * scaledHeight + additionalTopInset
    }
    
    private func computeLeftInsetToText() -> CGFloat {
        
        let inset: CGFloat
        if isLeftViewVisible && leftViewPosition == .left {
            inset = leftViewRect(forBounds: bounds).maxX + overlaySpaceToText
            
        } else if isRightViewVisible && rightViewPosition == .left {
            inset = leftViewRect(forBounds: bounds).maxX + overlaySpaceToText
            
        } else {
            inset = userInterfaceDirectionAwareTextPadding.left
        }
        
        return inset
    }
    
    private func computeRightInsetToText() -> CGFloat {
        
        let inset: CGFloat
        if isRightViewVisible && rightViewPosition == .right {
            inset = bounds.width - rightViewRect(forBounds: bounds).minX + overlaySpaceToText
            
        } else if isLeftViewVisible && leftViewPosition == .right {
            inset = bounds.width - rightViewRect(forBounds: bounds).minX + overlaySpaceToText
            
        } else {
            inset = userInterfaceDirectionAwareTextPadding.right
        }
        
        return inset
    }
    
    private func computeTopInsetToText() -> CGFloat {
        
        let placeholderOffset = placeholderMode.scalesPlaceholder ? scaledPlaceholderOffset : 0.0
        let inset = ceil(scaledPlaceholderHeight() + placeholderOffset + textPadding.top)
        
        return inset
    }
    
    private func computeBottomInsetToText() -> CGFloat {
        
        let inset = textPadding.bottom + underneathOffset
        
        return ceil(inset)
    }
    
    private func scaledPlaceholderHeight() -> CGFloat {
        guard placeholderMode.scalesPlaceholder else {
            return 0
        }
        
        return ceil(placeholderScaleWhenEditing * placeholderHeight)
    }
    
    // MARK: - Subviews Configurations
    
    private func setupPlaceholderContainerView() {
        placeholderContainerView.backgroundColor = .clear
        placeholderContainerView.isUserInteractionEnabled = false
        
        placeholderContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            placeholderContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            placeholderContainerView.topAnchor.constraint(equalTo: self.topAnchor),
            placeholderContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupPlaceholderView() {
//        placeholderLabel.font = _textFont
        placeholderView.textAlignment = textAlignment
        
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupUnderneathView() {
        underneathView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            underneathView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            underneathView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            underneathView.topAnchor.constraint(equalTo: self.bottomAnchor),
            underneathView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}


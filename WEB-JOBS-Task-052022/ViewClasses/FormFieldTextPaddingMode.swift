//
//  FormFieldTextPaddingMode.swift
//  Apollo
//
//  Created by Ahmed Shendy on 10/04/2022.
//

import Foundation

/// The different ways the text padding is applied to the subviews of the text field.
public enum FormFieldTextPaddingMode {
    
    /// Text padding is applied to the text.
    case text
    
    /// Text padding is applied to the text and the placeholder.
    case textAndPlaceholder
    
    /// Text padding is applied to the text, the placeholder and the hint.
    case textAndPlaceholderAndHint
    
    /// Text padding is applied to the text and the hint.
    case textAndHint
}

//
//  FormFieldPlaceholderMode.swift
//  Apollo
//
//  Created by Ahmed Shendy on 10/04/2022.
//

import Foundation

/// The different modes of the placeholder
public enum FormFieldPlaceholderMode {
    
    /// The default behavior of `UITextField`
    case simple
    
    /// The placeholder scales when it is not empty and when the text field is being edited
    case scalesWhenEditing
        
//    /// The placeholder scales when it is not empty
//    case scalesWhenNotEmpty
    
    /// The placeholder is locked in the transformed position above the text field
    case scalesAlways

    var scalesPlaceholder: Bool {
        switch self {
        case .simple:
            return false
        case .scalesWhenEditing:
            return true
//        case .scalesWhenNotEmpty:
//            return true
        case .scalesAlways:
            return true
        }
    }
}

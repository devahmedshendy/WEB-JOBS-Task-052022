//
//  String+Extension.swift
//  Apollo
//
//  Created by Ahmed Shendy on 09/04/2022.
//

import UIKit

extension String {
    var isNotEmpty: Bool { isEmpty == false }
}

extension String {
    
    func size(using font: UIFont, availableWidth: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        
        let size = CGSize(width: availableWidth, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [ .usesLineFragmentOrigin, .usesFontLeading ]
        let boundingRect = self.boundingRect(with: size, options: options, attributes: [ .font: font ], context: nil)
        let ceilSize = CGSize(width: ceil(boundingRect.width), height: ceil(boundingRect.height))
        
        return ceilSize
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(
            self,
            comment: ""
        )
    }
}

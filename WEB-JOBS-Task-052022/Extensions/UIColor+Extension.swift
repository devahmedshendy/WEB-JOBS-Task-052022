//
//  UIColor+Extension.swift
//  Apollo
//
//  Created by Ahmed Shendy on 24/04/2022.
//

import UIKit

extension UIColor {
    
    convenience init(_ name: String) {
        self.init(
            named: name,
            in: Bundle(for: AppDelegate.self),
            compatibleWith: nil
        )!
    }
}

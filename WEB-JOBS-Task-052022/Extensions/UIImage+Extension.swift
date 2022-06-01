//
//  UIImage+Extension.swift
//  Apollo
//
//  Created by Ahmed Shendy on 25/04/2022.
//

import UIKit

extension UIImage {
    
    convenience init(_ name: String) {
        self.init(
            named: name,
            in: Bundle(for: AppDelegate.self),
            compatibleWith: nil
        )!
    }
}

extension UIImage {

    func withInset(_ insets: UIEdgeInsets) -> UIImage? {
        let cgSize = CGSize(
            width: self.size.width + insets.left * self.scale + insets.right * self.scale,
            height: self.size.height + insets.top * self.scale + insets.bottom * self.scale
        )

        UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        let origin = CGPoint(x: insets.left * self.scale, y: insets.top * self.scale)
        self.draw(at: origin)

        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
    }
}

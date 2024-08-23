//
//  CALayer++.swift
//  Destination
//
//  Created by foyoodo on 2024/8/23.
//

import QuartzCore

extension CALayer {

    @discardableResult
    func setCornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.cornerRadius = cornerRadius
        if #available(iOS 13.0, *) {
            self.cornerCurve = .continuous
        }
        return self
    }

    func masksToBoundsAdjusted() {
        masksToBounds = cornerRadius > 0
    }
}

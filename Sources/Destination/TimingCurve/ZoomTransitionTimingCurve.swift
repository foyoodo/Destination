//
//  ZoomTransitionTimingCurve.swift
//  Destination
//
//  Created by foyoodo on 2024/8/21.
//

import UIKit

public final class ZoomTransitionTimingCurve: NSObject, UITimingCurveProvider {

    override init() {
        super.init()
    }

    required public convenience init?(coder: NSCoder) {
        self.init()
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        ZoomTransitionTimingCurve()
    }

    public func encode(with coder: NSCoder) {

    }

    public var timingCurveType: UITimingCurveType {
        .composed
    }

    public var cubicTimingParameters: UICubicTimingParameters? {
        .easeOutQuart()
    }

    public var springTimingParameters: UISpringTimingParameters? {
        .init(mass: 3, stiffness: 1000, damping: 94, initialVelocity: .zero)
    }
}

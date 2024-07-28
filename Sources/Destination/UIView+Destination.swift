//
//  UIView+Destination.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/26.
//

import UIKit

private var destinationKey: UInt8 = 0

public protocol DestinationCompatible {

}

extension DestinationCompatible where Self: UIView {

    public var destination: Destination<Self> {
        if let destination = objc_getAssociatedObject(self, &destinationKey) as? Destination<Self> {
            return destination
        } else {
            let destination = Destination(view: self)
            objc_setAssociatedObject(self, &destinationKey, destination, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return destination
        }
    }
}

extension UIView: DestinationCompatible { }

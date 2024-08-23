//
//  TransitionContext.swift
//  Destination
//
//  Created by foyoodo on 2024/8/23.
//

import UIKit

public protocol TransitionContext: AnyObject {

    var fromViewController: UIViewController? { get }

    var fromView: UIView? { get }
}

extension TransitionContext {

    public var fromView: UIView? {
        fromViewController?.view
    }
}

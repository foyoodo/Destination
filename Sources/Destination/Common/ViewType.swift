//
//  ViewType.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/26.
//

import UIKit

public protocol ViewType: AnyObject {

    associatedtype Presentation: UIView

    var presentation: Presentation { get }
}

extension ViewType where Self: UIView {

    public var presentation: Self {
        self
    }
}

extension UIView: ViewType { }

extension UIViewController: ViewType {

    public var presentation: UIView {
        view
    }
}

//
//  ViewFactory.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/26.
//

import UIKit

public protocol ViewFactoryType {

    associatedtype View: ViewType

    func createView() -> View
}

extension ViewFactoryType where View: UIView {

    public func createView() -> Self {
        self
    }
}

extension UIView: ViewFactoryType { }

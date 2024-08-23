//
//  PushPresentation.swift
//  Destination
//
//  Created by foyoodo on 2024/8/1.
//

import UIKit

open class PushPresentation<S: ViewType, D: ViewType>: ViewPresentationType where S: UIViewController, D: UIViewController {

    public typealias Source = S
    public typealias Destination = D

    open var isAnimated: Bool

    private var destination: Destination?

    public init(isAnimated: Bool = true) {
        self.isAnimated = isAnimated
    }

    open func present(source: Source, destination: Destination, transitionContext: ViewControllerTransitionContext) {
        source.navigationController?.pushViewController(destination, animated: isAnimated)
        self.destination = destination
    }

    open func present(source: Source, destination: Destination) where Source: UINavigationController, Destination: UIViewController {
        source.pushViewController(destination, animated: isAnimated)
        self.destination = destination
    }
}

extension PushPresentation: Dismissible {

    open func dismiss(transitionContext: ViewControllerTransitionContext, completion: (() -> Void)?) {
        dismiss(completion: completion)
    }

    open func dismiss(completion: (() -> Void)?) {
        destination?.dismiss(animated: isAnimated, completion: completion)
    }

    open func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        isAnimated = animated
        dismiss(completion: completion)
    }
}

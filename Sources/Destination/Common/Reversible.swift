//
//  Reversible.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/28.
//

public protocol Reversible: AnyObject {

    func reverse(completion: ((_ reversible: Reversible) -> Void)?)
}

extension Reversible {

    public func reverse() {
        reverse(completion: nil)
    }
}

public protocol Dismissible {

    associatedtype Context: TransitionContext

    func dismiss(transitionContext: Context, completion: (() -> Void)?)
}

extension Dismissible {

    public func dismiss(transitionContext: Context) {
        dismiss(transitionContext: transitionContext, completion: nil)
    }
}

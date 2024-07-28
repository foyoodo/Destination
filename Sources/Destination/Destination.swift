//
//  Destination.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/26.
//

import UIKit

public final class Destination<Host: UIView> {

    public private(set) var view: Host?

    var transition: (any ViewTransitionType)?

    public var reversible: (any Reversible)? {
        transition as? (any Reversible)
    }

    init(view: Host) {
        self.view = view
    }

    public func transition<Container: UIView, Host>(container: Container) -> ViewTransition<DestinationViewFactory<Host>, ContainerPresentation<Container>> {
        guard let host = view else {
            preconditionFailure()
        }
        let presentation = ContainerPresentation(containerView: container)
        let transition = ViewTransition(destinationViewFactory: DestinationViewFactory(host), viewPresentation: presentation)
        return transition
    }

    public func transition<Container: UIView, Source: UIView>(from sourceView: Source, container: Container) {
        guard let host = view else {
            preconditionFailure()
        }
        let transition = transition(container: container)
        transition.performTransition(sourceView: sourceView)
        self.transition = ReversibleViewTransition(transition)
    }

//    public func transition(from sourceView: UIView, viewPresentation: AnyViewPresentation<UIView, UIView>) {
//        guard let host = view else {
//            preconditionFailure()
//        }
//        let transition = ViewTransition(destinationViewFactory: DestinationViewFactory(host), viewPresentation: viewPresentation)
//        transition.performTransition(sourceView: sourceView)
//        self.transition = transition
//    }
}

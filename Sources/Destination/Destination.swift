//
//  Destination.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/26.
//

import UIKit

public final class Destination<Host: ViewType> {

    public private(set) weak var host: Host?

    var transition: (any ViewTransitionType)?

    public var reversible: (any Reversible)? {
        transition as? (any Reversible)
    }

    init(_ host: Host) {
        self.host = host
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

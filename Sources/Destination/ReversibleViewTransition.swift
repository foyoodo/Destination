//
//  ReversibleViewTransition.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/28.
//

import UIKit

struct ReversibleViewTransition<
    DestinationFactory: ViewFactoryType,
    Presentation: ViewPresentationType & Dismissible
>: ViewTransitionType, Reversible where DestinationFactory.View == Presentation.Destination {

    var transition: ViewTransition<DestinationFactory, Presentation>

    init(_ transition: ViewTransition<DestinationFactory, Presentation>) {
        self.transition = transition
    }

    @discardableResult
    func performTransition(sourceView: Presentation.Source) -> Self {
        transition._performTransition(sourceView: sourceView)
        return self
    }

    func reverse(completion: (() -> Void)?) {
        transition.viewPresentation.dismiss(completion: completion)
    }
}

extension ViewTransition where Presentation: Dismissible {

    public func performTransition(sourceView: Presentation.Source) -> Reversible {
        _performTransition(sourceView: sourceView)
        return ReversibleViewTransition(self)
    }
}

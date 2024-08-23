//
//  ViewTransition.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/25.
//

import UIKit

public protocol ViewTransitionType {

    associatedtype Source: ViewType

    associatedtype Output

    func performTransition(sourceView: Source) -> Output
}

public final class ViewTransition<
    DestinationFactory: ViewFactoryType,
    Presentation: ViewPresentationType
>: ViewTransitionType where DestinationFactory.View == Presentation.Destination {

    let destinationViewFactory: DestinationFactory

    let viewPresentation: Presentation

    var context: Presentation.Context

    public init(
        destinationViewFactory: DestinationFactory,
        viewPresentation: Presentation,
        context: Presentation.Context
    ) {
        self.destinationViewFactory = destinationViewFactory
        self.viewPresentation = viewPresentation
        self.context = context
    }

    func _performTransition(sourceView: Presentation.Source) {
        let destinationView = destinationViewFactory.createView()
        viewPresentation.present(source: sourceView, destination: destinationView, transitionContext: context)
    }

    public func performTransition(sourceView: Presentation.Source) {
        _performTransition(sourceView: sourceView)
    }
}

extension ViewTransition: Reversible where Presentation: Dismissible {

    public func reverse(completion: ((_ reversible: Reversible) -> Void)? = nil) {
        viewPresentation.dismiss(transitionContext: context) {
            completion?(self)
        }
    }

    @discardableResult
    public func performTransition(sourceView: Presentation.Source) -> Reversible {
        _performTransition(sourceView: sourceView)
        return self
    }
}

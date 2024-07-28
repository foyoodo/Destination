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

    public init(
        destinationViewFactory: DestinationFactory,
        viewPresentation: Presentation
    ) {
        self.destinationViewFactory = destinationViewFactory
        self.viewPresentation = viewPresentation
    }

    public func _performTransition(sourceView: Presentation.Source) {
        let destinationView = destinationViewFactory.createView()
        viewPresentation.present(sourceView: sourceView, destinationView: destinationView)
    }

    public func performTransition(sourceView: Presentation.Source) {
        _performTransition(sourceView: sourceView)
    }
}

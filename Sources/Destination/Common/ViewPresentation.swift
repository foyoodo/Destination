//
//  ViewPresentation.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/26.
//

import UIKit

public protocol ViewPresentationType {

    associatedtype Context: TransitionContext

    associatedtype Source: ViewType

    associatedtype Destination: ViewType

    func present(source: Source, destination: Destination, transitionContext: Context)
}

public final class AnyViewPresentation<Source: ViewType, Destination: ViewType, Context: TransitionContext>: ViewPresentationType {

    private let _performPresentation: (Source, Destination, Context) -> ()

    public init<Presentation: ViewPresentationType>(_ presentation: Presentation) where Presentation.Source == Source, Presentation.Destination == Destination, Presentation.Context == Context {
        self._performPresentation = { presentation.present(source: $0, destination: $1, transitionContext: $2) }
    }

    public func present(source: Source, destination: Destination, transitionContext: Context) {
        _performPresentation(source, destination, transitionContext)
    }
}

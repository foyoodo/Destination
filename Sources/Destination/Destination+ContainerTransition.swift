//
//  Destination+ContainerTransition.swift
//  Destination
//
//  Created by foyoodo on 2024/8/23.
//

import UIKit

extension Destination where Host.Presentation: UIView {

    public func transition<Container: UIView>(
        container: Container,
        configContext: ((ContainerTransitionContext) -> ()) = { _ in }
    ) -> ViewTransition<Host.Presentation, ContainerPresentation<Container>> {
        guard let host else {
            preconditionFailure()
        }

        let presentation = ContainerPresentation(containerView: container)

        let context = ContainerTransitionContext()

        configContext(context)

        return .init(destinationViewFactory: host.presentation, viewPresentation: presentation, context: context)
    }

    @discardableResult
    public func transition<Container: UIView, Source: UIView>(from sourceView: Source, container: Container) -> Reversible {
        guard let host else {
            preconditionFailure()
        }

        let transition = transition(container: container)

        defer {
            transition.performTransition(sourceView: sourceView)
        }

        self.transition = transition

        return transition
    }
}

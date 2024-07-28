//
//  ViewPresentation.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/26.
//

import UIKit

public protocol ViewPresentationType {

    associatedtype Source: ViewType

    associatedtype Destination: ViewType

    func present(sourceView: Source, destinationView: Destination)
}

public final class AnyViewPresentation<Source: ViewType, Destination: ViewType>: ViewPresentationType {

    private let _performPresentation: (Source, Destination) -> ()

    public init<Presentation: ViewPresentationType>(_ presentation: Presentation) where Presentation.Source == Source, Presentation.Destination == Destination {
        self._performPresentation = { presentation.present(sourceView: $0, destinationView: $1) }
    }

    public func present(sourceView: Source, destinationView: Destination) {
        _performPresentation(sourceView, destinationView)
    }
}

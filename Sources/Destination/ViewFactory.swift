//
//  ViewFactory.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/26.
//

import UIKit

public protocol ViewFactoryType {

    associatedtype View: ViewType

    func createView() -> View
}

public struct DestinationViewFactory<Destination: UIView>: ViewFactoryType {

    let destinationView: Destination

    init(_ destinationView: Destination) {
        self.destinationView = destinationView
    }

    public func createView() -> Destination {
        destinationView
    }
}

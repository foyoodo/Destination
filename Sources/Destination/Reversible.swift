//
//  Reversible.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/28.
//

public protocol Reversible {

    func reverse(completion: (() -> Void)?)
}

extension Reversible {

    public func reverse() {
        reverse(completion: nil)
    }
}

public protocol Dismissible {

    func dismiss(completion: (() -> Void)?)
}

extension Dismissible {

    public func dismiss() {
        dismiss(completion: nil)
    }
}

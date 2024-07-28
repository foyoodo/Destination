//
//  TransitionView.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/28.
//

import UIKit

class TransitionView: UIView {

    let sourceView: UIView

    let destinationView: UIView

    init(frame: CGRect = .zero, sourceView: UIView, destinationView: UIView) {
        self.sourceView = sourceView
        self.destinationView = destinationView
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

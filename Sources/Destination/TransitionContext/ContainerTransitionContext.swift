//
//  ContainerTransitionContext.swift
//  Destination
//
//  Created by foyoodo on 2024/8/23.
//

import UIKit

public final class ContainerTransitionContext: TransitionContext {

    public var fromViewController: UIViewController?

    public var sourceViewTransitioning: Bool = false

    public var blurEffectStyle: UIBlurEffect.Style?
}

//
//  ContainerPresentation.swift
//  ViewTransition
//
//  Created by foyoodo on 2024/7/28.
//

import UIKit

open class ContainerPresentation<Container: UIView>: ViewPresentationType, Dismissible {

    public let containerView: Container

    private var transitionView: TransitionView?

    public init(containerView: Container) {
        self.containerView = containerView
    }

    open func present(sourceView: UIView, destinationView: UIView) {
        guard let sourceViewSnapshot = sourceView.snapshotView(afterScreenUpdates: false) else {
            return
        }

        let transitionView = TransitionView(sourceView: sourceView, destinationView: destinationView)

        self.transitionView = transitionView

        containerView.addSubview(transitionView)
        transitionView.frame = containerView.bounds

        let convertedSourceFrame = sourceView.convert(sourceView.bounds, to: transitionView)
        let startFrame = CGRect(origin: convertedSourceFrame.origin, size: .init(width: convertedSourceFrame.width, height: transitionView.bounds.height * (convertedSourceFrame.width / transitionView.bounds.width)))
        let targetFrame = transitionView.bounds

        let maskView = UIView()
        maskView.backgroundColor = .black
        maskView.frame = sourceView.bounds
        maskView.layer.cornerRadius = sourceView.layer.cornerRadius
        maskView.layer.cornerCurve = .continuous

        destinationView.frame = startFrame
        destinationView.backgroundColor = .systemRed
        destinationView.mask = maskView

        transitionView.addSubview(destinationView)

        sourceViewSnapshot.frame = sourceView.bounds
        sourceViewSnapshot.backgroundColor = sourceView.backgroundColor
        sourceViewSnapshot.contentMode = .top

        destinationView.addSubview(sourceViewSnapshot)

        transitionView.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0) { [self] in
            maskView.layer.cornerRadius = transitionView.window?.screen.displayCornerRadius ?? 0
            maskView.frame = targetFrame
            destinationView.frame = targetFrame
            sourceViewSnapshot.frame = targetFrame
            sourceViewSnapshot.alpha = 0
        } completion: { _ in
            destinationView.mask = nil
            sourceViewSnapshot.removeFromSuperview()
        }
    }

    open func dismiss(completion: (() -> Void)?) {
        guard let transitionView,
              let sourceViewSnapshot = transitionView.sourceView.snapshotView(afterScreenUpdates: false)
        else {
            transitionView?.removeFromSuperview()
            return
        }

        let sourceView = transitionView.sourceView
        let destinationView = transitionView.destinationView

        let maskView = UIView()
        maskView.backgroundColor = .black
        maskView.frame = transitionView.bounds
        maskView.layer.cornerRadius = transitionView.window?.screen.displayCornerRadius ?? 0
        maskView.layer.cornerCurve = .continuous

        destinationView.mask = maskView

        let convertedTargetFrame = sourceView.convert(sourceView.bounds, to: transitionView)
        let targetFrame = CGRect(origin: convertedTargetFrame.origin, size: .init(width: convertedTargetFrame.width, height: transitionView.bounds.height * (convertedTargetFrame.width / transitionView.bounds.width)))

        destinationView.addSubview(sourceViewSnapshot)
        sourceViewSnapshot.frame = destinationView.convert(destinationView.frame, from: transitionView)
        sourceViewSnapshot.alpha = 0
        sourceViewSnapshot.contentMode = .top
        sourceViewSnapshot.backgroundColor = sourceView.backgroundColor

        transitionView.layoutIfNeeded()

        UIView.transition(with: destinationView, duration: 0.25) {
            sourceViewSnapshot.alpha = 1
        }

        sourceView.isHidden = true

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1) { [self] in
            maskView.frame = sourceView.bounds
            maskView.layer.cornerRadius = sourceView.layer.cornerRadius
            destinationView.frame = targetFrame
            sourceViewSnapshot.frame = CGRect(origin: .zero, size: targetFrame.size)
            sourceViewSnapshot.alpha = 1
        } completion: { _ in
            sourceView.isHidden = false
            transitionView.removeFromSuperview()
            self.transitionView = nil
            completion?()
        }
    }
}

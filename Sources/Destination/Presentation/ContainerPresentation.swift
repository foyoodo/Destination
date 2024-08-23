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

    open func present(source: UIView, destination: UIView, transitionContext: ContainerTransitionContext) {
        let sourceView = source
        let destinationView = destination

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
        destinationView.mask = maskView

        transitionView.addSubview(destinationView)

        sourceViewSnapshot.frame = sourceView.bounds
        sourceViewSnapshot.backgroundColor = sourceView.backgroundColor
        sourceViewSnapshot.contentMode = .top

        destinationView.addSubview(sourceViewSnapshot)

        transitionView.layoutIfNeeded()

        let fromView = transitionContext.fromView
        fromView?.layer.setCornerRadius(fromView?.window?.screen.displayCornerRadius ?? 0).masksToBoundsAdjusted()

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allowUserInteraction) { [self] in
            fromView?.layer.cornerRadius = 20
            fromView?.layer.transform = CATransform3DMakeScale(0.88, 0.88, 1)
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

    open func dismiss(transitionContext: ContainerTransitionContext, completion: (() -> Void)?) {
        guard let transitionView else {
            transitionView?.removeFromSuperview()
            return
        }

        let sourceView = transitionView.sourceView
        let destinationView = transitionView.destinationView

        let sourceViewSnapshot: UIView
        let sourceViewIsSnapshot = !transitionContext.sourceViewTransitioning

        if transitionContext.sourceViewTransitioning {
            sourceViewSnapshot = sourceView
        } else {
            let image = UIGraphicsImageRenderer(bounds: sourceView.bounds).image { context in
                sourceView.drawHierarchy(in: sourceView.bounds, afterScreenUpdates: true)
            }

            sourceViewSnapshot = UIImageView(image: image)
        }

        let maskView = UIView()
        maskView.backgroundColor = .black
        maskView.frame = transitionView.bounds
        maskView.layer.cornerRadius = transitionView.window?.screen.displayCornerRadius ?? 0
        maskView.layer.cornerCurve = .continuous

        destinationView.mask = maskView

        let convertedTargetFrame = sourceView.convert(sourceView.bounds, to: transitionView)
        let destinationTargetFrame = CGRect(origin: .init(x: 0, y: convertedTargetFrame.origin.y), size: transitionView.bounds.size)

        let scale = convertedTargetFrame.width / transitionView.bounds.width
        let translation = (transitionView.bounds.height - convertedTargetFrame.height) / 2

        let offset = CGPoint(x: (transitionView.bounds.width - convertedTargetFrame.width) / 2,
                             y: (transitionView.bounds.height - convertedTargetFrame.height) / 2)

        let maskFrame = CGRect(origin: .init(x: (transitionView.bounds.width - convertedTargetFrame.width) / 2, y: 0), size: sourceView.bounds.size)

        let targetFrame: CGRect

        if sourceViewIsSnapshot {
            sourceViewSnapshot.frame = destinationView.frame
            sourceViewSnapshot.contentMode = .top
            sourceView.isHidden = true
            targetFrame = CGRect(origin: convertedTargetFrame.origin, size: .init(width: convertedTargetFrame.width, height: transitionView.bounds.height * (convertedTargetFrame.width / transitionView.bounds.width)))
        } else {
            sourceViewSnapshot.removeFromSuperview()
            sourceViewSnapshot.frame = CGRect(origin: .init(x: offset.x, y: destinationView.frame.origin.y), size: convertedTargetFrame.size)
            targetFrame = convertedTargetFrame
        }

        sourceViewSnapshot.alpha = 0

        transitionView.addSubview(sourceViewSnapshot)

        var visualEffectView: UIVisualEffectView?

        if let blurEffectStyle = transitionContext.blurEffectStyle {
            let effectView = UIVisualEffectView(effect: UIBlurEffect(style: blurEffectStyle))
            effectView.layer.cornerRadius = maskView.layer.cornerRadius
            effectView.layer.cornerCurve = sourceView.layer.cornerCurve
            effectView.layer.masksToBounds = true
            effectView.frame = destinationView.frame
            visualEffectView = effectView
            transitionView.insertSubview(effectView, at: 0)
        }

        transitionView.layoutIfNeeded()

        let fromView = transitionContext.fromView

        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: ZoomTransitionTimingCurve())

        animator.addAnimations {
            fromView?.layer.transform = CATransform3DIdentity
            fromView?.layer.cornerRadius = fromView?.window?.screen.displayCornerRadius ?? 0
            maskView.frame = maskFrame
            maskView.layer.cornerRadius = sourceView.layer.cornerRadius
            destinationView.frame = destinationTargetFrame
            sourceViewSnapshot.frame = targetFrame
            sourceViewSnapshot.alpha = 1
            if let visualEffectView {
                visualEffectView.frame = targetFrame
                visualEffectView.layer.cornerRadius = sourceView.layer.cornerRadius
                destinationView.alpha = 0
            }
        }

        animator.addCompletion { _ in
            fromView?.layer.cornerRadius = 0
            sourceView.isHidden = false
            destinationView.mask = nil
            destinationView.alpha = 1
            sourceViewSnapshot.removeFromSuperview()
            transitionView.removeFromSuperview()
            self.transitionView = nil
            completion?()
        }

        animator.startAnimation()
    }
}

//
//  PopAnimator.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/19/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

// MARK: - UIViewControllerAnimatedTransitioning

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    var isPresenting = true
    var originFrame = CGRect.zero
  
    var dismissCompletion: (() -> Void)?
  
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
  
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let detailView = isPresenting ? transitionContext.view(forKey: .to)! : transitionContext.view(forKey: .from)!
        
        if isPresenting {
            detailView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    
        let initialFrame = isPresenting ? originFrame : detailView.frame
        let finalFrame = isPresenting ? detailView.frame : originFrame
    
        let xScaleFactor = isPresenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
    
        let yScaleFactor = isPresenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
    
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    
        if isPresenting {
            detailView.transform = scaleTransform
            detailView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            detailView.clipsToBounds = true
        }
    
        detailView.layer.cornerRadius = isPresenting ? 20.0 : 0.0
        detailView.layer.masksToBounds = true
    
        containerView.addSubview(detailView)
        containerView.bringSubviewToFront(detailView)
    
        UIView.animate(withDuration: duration, delay:0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, animations: {
            detailView.transform = self.isPresenting ? .identity : scaleTransform
            detailView.alpha = self.isPresenting ? 1.0 : 0.0
            detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            detailView.layer.cornerRadius = !self.isPresenting ? 20.0 : 0.0
        }, completion: { _ in
            if !self.isPresenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })
    }
  
    private func handleRadius(detailView: UIView, hasRadius: Bool) {
        detailView.layer.cornerRadius = hasRadius ? 20.0 : 0.0
    }
    
}


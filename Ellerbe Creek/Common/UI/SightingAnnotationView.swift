//
//  SightingAnnotationView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/5/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import Mapbox

class SightingAnnotationView: MGLAnnotationView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
         
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width * 0.5
        layer.borderWidth = 4
        layer.borderColor = Colors.darkOrange.cgColor
        
        // Add pulsing effect to the root layer
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 2
        opacityAnimation.fromValue = 0.85
        opacityAnimation.toValue = 1
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        opacityAnimation.autoreverses = true
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        layer.add(opacityAnimation, forKey: "animateOpacity")
        
        // Add scaling effect to the root layer
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2
        scaleAnimation.fromValue = Double.random(in: 0.8..<0.95)
        scaleAnimation.toValue = Double.random(in: 1.05..<1.2)
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        layer.add(scaleAnimation, forKey: "animateScale")
        
    }
     
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
         
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? bounds.width * 0.2 : 4
        layer.add(animation, forKey: "borderWidth")
    }
    
}

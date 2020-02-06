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

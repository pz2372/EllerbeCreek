//
//  NavigationHeaderView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/4/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class NavigationHeaderView: NibBasedView {
    
    @IBOutlet var textLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.textAlignment = .right
                label.textColor = Colors.white
            }
        }
    }
    
    @IBOutlet var detailTextLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.semibold.withSize(32.0)
                label.textAlignment = .left
                label.textColor = Colors.white
            }
        }
    }
    
    @IBOutlet var detailTextLabelWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        contentView.backgroundColor = Colors.darkGreen
        detailTextLabelWidthConstraint.isActive = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Masks the contentView so that the bottom boundary is curved
        let arcCenter = CGPoint(x: bounds.size.width / 2, y: -(3.0*bounds.size.width)+bounds.size.height)
        let circleRadius = 3.0*bounds.size.width
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: 0.0, endAngle: CGFloat.pi, clockwise: true)

        let semiCirleLayer = CAShapeLayer()
        semiCirleLayer.path = circlePath.cgPath
        
        contentView.layer.mask = semiCirleLayer
        
        // Adds a shadow to the bottom of the view
        layer.shadowPath = circlePath.cgPath
        layer.shadowColor = Colors.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0.0, height: -10.0)
        layer.shadowRadius = 20
    }

}

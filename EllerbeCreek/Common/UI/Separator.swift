//
//  Separator.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/25/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

enum SeparatorStyle {
    case horizontal
    case vertical
}

class Separator: UIView {
    
    public var style: SeparatorStyle = .horizontal {
        didSet {
            updateStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = Colors.lightGreen
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateStyle()
    }
    
    private func updateStyle() {
        switch style {
        case .horizontal:
            layer.cornerRadius = bounds.height * 0.5
        case .vertical:
            layer.cornerRadius = bounds.width * 0.5
            let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 6)
            NSLayoutConstraint.activate([widthConstraint])
        }
        layer.masksToBounds = true
    }
    
}

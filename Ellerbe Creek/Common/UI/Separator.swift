//
//  Separator.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/25/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class Separator: UIView {
    
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
        
        layer.cornerRadius = bounds.height * 0.5
        layer.masksToBounds = true
    }
    
}

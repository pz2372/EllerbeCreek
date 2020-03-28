//
//  WelcomeView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/23/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class WelcomeView: NibBasedView {
    
    public weak var delegate: OnboardingViewDelegate?
    
    @IBOutlet var subHeaderLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.semibold.withSize(24.0)
                label.textColor = Colors.black
            }
        }
    }
    
    @IBOutlet var headerLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.bold.withSize(48.0)
                label.textColor = Colors.darkGreen
            }
        }
    }
    
    @IBOutlet var imageView: UIImageView! {
        willSet {
            if let imageView: UIImageView = newValue {
                let templateImage = UIImage(named: "EllerbeCreek")?.withRenderingMode(.alwaysTemplate)
                imageView.image = templateImage
                imageView.tintColor = Colors.lightGreen
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
           
        setUp()
    }
       
    required init?(coder: NSCoder) {
        super.init(coder: coder)
           
        setUp()
    }
    
    private func setUp() {
        
    }
    
}

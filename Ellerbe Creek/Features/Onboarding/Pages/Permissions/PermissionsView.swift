//
//  PermissionsView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/22/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class PermissionsView: NibBasedView {
    
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
    
    @IBOutlet var locationPermissionDescription: PermissionDescriptionView! {
        willSet {
            if let view: PermissionDescriptionView = newValue {
                view.type = .location
            }
        }
    }
    
    @IBOutlet var notificationPermissionDescription: PermissionDescriptionView! {
        willSet {
            if let view: PermissionDescriptionView = newValue {
                view.type = .notifications
            }
        }
    }
    
    @IBOutlet var cameraPermissionDescription: PermissionDescriptionView! {
        willSet {
            if let view: PermissionDescriptionView = newValue {
                view.type = .camera
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

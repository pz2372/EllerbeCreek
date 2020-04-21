//
//  PermissionDescriptionView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/24/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

enum PermissionType {
    case location
    case notifications
    case camera
}

class PermissionDescriptionView: NibBasedView {
    
    public var type: PermissionType? {
        didSet {
            updateType()
        }
    }
    
    @IBOutlet var descriptionLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.semibold.withSize(28.0)
                label.textAlignment = .left
                label.textColor = Colors.black
            }
        }
    }
    
    @IBOutlet var switchControl: UISwitch! {
        willSet {
            if let switchControl: UISwitch = newValue {
                switchControl.setOn(false, animated: false)
                switchControl.onTintColor = Colors.lightGreen
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
              
        commonInit()
    }
          
    required init?(coder: NSCoder) {
        super.init(coder: coder)
              
        commonInit()
    }
       
    private func commonInit() {
        backgroundColor = .clear
    }
    
    private func updateType() {
        guard let type = type else { return }
        switch type {
        case .location:
            descriptionLabel.text = "Location"
        case .notifications:
            descriptionLabel.text = "Notifications"
        case .camera:
            descriptionLabel.text = "Camera"
        }
    }
    
    @IBAction func switchControlAction() {
        if switchControl.isOn {
            guard let type = type else { return }
            switch type {
            case .location:
                checkLoationPermissions()
            case .notifications:
                checkNotificationPermissions()
            case .camera:
                checkCameraPermissions()
            }
        }
    }
    
    private func checkLoationPermissions() {
        PermissionsHelper.shared.askForLocationPermission()
    }
    
    private func checkNotificationPermissions() {
        PermissionsHelper.shared.askForNotificationPermission()
    }
    
    private func checkCameraPermissions() {
        PermissionsHelper.shared.askForCameraPermission()
    }
    
}

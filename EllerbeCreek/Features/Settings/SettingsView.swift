//
//  SettingsView.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/27/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class SettingsView: NibBasedView {
    
    // MARK: Public Variables
    
    public weak var delegate: SettingsViewControllerDelegate?
    
    private var sightingDistance: Double {
        return UserDefaults.standard.double(forKey: UserDefaults.Keys.sightingDistance)
    }
    
    // MARK: Interface Objects
    
    @IBOutlet var dismissButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setBackgroundImage(UIImage(named: "Close"), for: .normal)
                
                button.layer.shadowColor = Colors.black.cgColor
                button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius = 6.0
            }
        }
    }
    
    @IBOutlet var cardView: UIView! {
        willSet {
            if let view: UIView = newValue {
                view.backgroundColor = Colors.background
                view.layer.cornerRadius = 24.0
                view.layer.masksToBounds = true
            }
        }
    }
    
    @IBOutlet var notificationDistanceDetailLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.bold.withSize(24.0)
                label.textColor = Colors.black
                label.text = "Sighting Distance"
            }
        }
    }
    
    @IBOutlet var notificationDistanceValueLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.semibold.withSize(20.0)
                label.textColor = Colors.black
                label.text = "\(Int(sightingDistance*3.2808)) ft"
                label.textAlignment = .center
            }
        }
    }
    
    @IBOutlet var notificationDistanceSlider: UISlider! {
        willSet {
            if let slider: UISlider = newValue {
                slider.value = Float(sightingDistance*3.2808)
                slider.maximumValue = 500
                slider.minimumValue = 100
                slider.tintColor = Colors.lightGreen
            }
        }
    }
    
    // MARK: View Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commontInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commontInit()
    }
    
    private func commontInit() {
        self.contentView.backgroundColor = Colors.black.withAlphaComponent(0.0)
        UIView.animate(withDuration: 4.0, animations: {
            self.contentView.backgroundColor = Colors.black.withAlphaComponent(0.36)
        })
    }
    
    // MARK: Button Actions
    
    @IBAction func dismissButtonAction() {
        guard let delegate = delegate else { return }
        self.contentView.backgroundColor = Colors.black.withAlphaComponent(0.0)
        delegate.showProfile()
    }
    
    @IBAction func notificationDistanceSliderValueChanged() {
        UserDefaults.standard.set(Double(notificationDistanceSlider.value/3.2808), forKey: UserDefaults.Keys.sightingDistance)
        notificationDistanceValueLabel.text = "\(Int(sightingDistance*3.2808)) ft"
    }
    
}


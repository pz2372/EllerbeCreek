//
//  UserCreationView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/22/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import GameKit

class UserCreationView: NibBasedView {
    
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
    
    @IBOutlet var separatorDescriptorLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.semibold.withSize(20.0)
                label.textColor = Colors.black
                label.textAlignment = .center
                label.text = "or"
            }
        }
    }
    
    @IBOutlet var gameCenterButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setBackgroundImage(UIImage(named: "GameCenter"), for: .normal)
                
                button.layer.shadowColor   = Colors.black.cgColor
                button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius  = 6.0
            }
        }
    }
    
    @IBOutlet var customButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setBackgroundImage(UIImage(named: "Custom"), for: .normal)
                
                button.layer.shadowColor   = Colors.black.cgColor
                button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius  = 6.0
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
    
    @IBAction func gameCenterAction() {
        checkGKAuth()
    }
    
    @IBAction func customAction() {
        
    }
    
    func checkGKAuth() {
        GKLocalPlayer.local.authenticateHandler = { gcAuthVC, error in
            if GKLocalPlayer.local.isAuthenticated {
                guard let delegate = self.delegate else { return }
                delegate.triggerScrollToNextSlide()
            } else if let vc = gcAuthVC {
                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true)
            } else {
                print("Error authentication to GameCenter: " + "\(error?.localizedDescription ?? "none")")
            }
        }
    }
    
}

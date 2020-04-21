//
//  NewSessionView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/30/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class NewSessionView: NibBasedView {
    
    // MARK: Private Constants
    
    private let gradientLayer: CAGradientLayer = {
           let layer = CAGradientLayer()
           layer.colors = [Colors.white.withAlphaComponent(0).cgColor, Colors.background.cgColor]
           layer.startPoint = CGPoint(x: 0.5, y: 0.0)
           layer.endPoint = CGPoint(x: 0.5, y: 0.6)
           return layer
        }()
    
    // MARK: Public Variables
    
    public weak var delegate: NewSessionViewControllerDelegate?
    
    // MARK: Private Variables
    
    private var preserve: Preserve!
    
    // MARK: Interface Objects
    
    @IBOutlet var descriptionLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.semibold.withSize(28.0)
                label.textAlignment = .center
                label.textColor = Colors.black
                label.numberOfLines = 2
                
                label.text = "Looks like you're\nat"
            }
        }
    }
    
    @IBOutlet var preserveLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.bold.withSize(44.0)
                label.textAlignment = .center
                label.textColor = Colors.black
                label.numberOfLines = 0
        
                label.layer.shadowColor = Colors.black.cgColor
                label.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                label.layer.shadowOpacity = 0.2
                label.layer.shadowRadius = 6.0
            }
        }
    }
    
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
    
    @IBOutlet var newSessionButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setBackgroundImage(UIImage(named: "NewGame"), for: .normal)
                               
                button.layer.shadowColor = Colors.black.cgColor
                button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius = 6.0
            }
        }
    }
    
    // MARK: View Initialization
    
    required init(preserve: Preserve) {
        self.preserve = preserve
        super.init(frame: .zero)
        commonInit()
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
        layer.insertSublayer(gradientLayer, at: 0)
        
        if let preserveName = preserve.name {
            preserveLabel.text = "\(preserveName)\nPreserve"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    // MARK: Button Actions
    
    @IBAction func dismissAction() {
        guard let delegate = delegate else { return }
        delegate.dismiss()
    }
    
    @IBAction func newSessionAction() {
        guard let delegate = delegate, let preserve = preserve else { return }
        SessionManager.shared.start(at: preserve)
        delegate.startNewSession()
    }
    
}

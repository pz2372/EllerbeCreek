//
//  SightingDetailView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/24/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class SightingDetailView: NibBasedView {
    
    public weak var delegate: SightingDetailViewControllerDelegate?
    
    @IBOutlet var dismissButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setImage(UIImage(named: "Close"), for: .normal)
                
                button.layer.shadowColor   = Colors.black.cgColor
                button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius  = 6.0
            }
        }
    }
    
    @IBOutlet var imageView: UIImageView! {
        willSet {
            if let imageView: UIImageView = newValue {
                imageView.layer.shadowColor   = Colors.black.cgColor
                imageView.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                imageView.layer.shadowOpacity = 0.16
                imageView.layer.shadowRadius  = 10.0
            }
        }
    }
    
    @IBOutlet var pointsLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.textAlignment = .right
                label.font = Fonts.semibold.withSize(24.0)
            }
        }
    }
    
    @IBOutlet var nameLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.textAlignment = .left
                label.font = Fonts.semibold.withSize(24.0)
            }
        }
    }
    
    @IBOutlet var infoTextView: UITextView! {
        willSet {
            if let textView: UITextView = newValue {
                textView.backgroundColor = UIColor.clear
                textView.font = Fonts.regular.withSize(21.0)
            }
        }
    }
    
    @IBOutlet var shareButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setImage(UIImage(named: "Share"), for: .normal)
                
                button.layer.shadowColor   = Colors.black.cgColor
                button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius  = 6.0
            }
        }
    }
    
    @IBOutlet var moreButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setImage(UIImage(named: "More"), for: .normal)
                
                button.layer.shadowColor   = Colors.black.cgColor
                button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius  = 6.0
            }
        }
    }
    
    var points = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUp()
    }
    
    private func setUp() {
        contentView.backgroundColor = Colors.background
        
        setDetail(with: points)
    }
    
    @IBAction func dismissButtonAction() {
        guard let delegate = delegate else { return }
        delegate.showGameMap()
    }
    
    private func setDetail(with value: Int) {
        let nameText = NSMutableAttributedString.init(string: value == 1 ? "+\(value) point" : "+\(value) points")

        // Adds a custom font and size for sightings value in the headerText string
        nameText.setAttributes([NSAttributedString.Key.font: Fonts.bold.withSize(28.0)],
                                 range: NSMakeRange(0, "\(value)".count+1))
        
        // Vertically centers the 'sightings nearby' description following the sighting value in the headerText string
        nameText.setAttributes([NSAttributedString.Key.baselineOffset: 2.0], range: NSMakeRange("\(value)".count, nameText.length-1))

        pointsLabel.attributedText = nameText
    }
    
}

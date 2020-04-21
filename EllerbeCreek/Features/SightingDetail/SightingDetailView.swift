//
//  SightingDetailView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/24/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class SightingDetailView: NibBasedView {
    
    // MARK: Public Variables
    
    public weak var delegate: SightingDetailViewControllerDelegate?
    
    // MARK: Private Variables
    
    private var sighting: Sighting!
    private var animalInfoLink: String?
    
    // MARK: Interface Objects
    
    @IBOutlet var dismissButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setBackgroundImage(UIImage(named: "Close"), for: .normal)
                
                button.layer.shadowColor   = Colors.black.cgColor
                button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius  = 6.0
            }
        }
    }
    
    @IBOutlet var pointsLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.semibold.withSize(24.0)
                label.textAlignment = .right
                label.textColor = Colors.black
            }
        }
    }
    
    @IBOutlet var animalNameLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.adjustsFontSizeToFitWidth = true
                label.font = Fonts.semibold.withSize(44.0)
                label.numberOfLines = 1
                label.textAlignment = .left
                label.textColor = Colors.black
            }
        }
    }
    
    @IBOutlet var animalDescriptionTextView: UITextView! {
        willSet {
            if let textView: UITextView = newValue {
                textView.backgroundColor = UIColor.clear
                textView.font = Fonts.regular.withSize(21.0)
                textView.textAlignment = .left
                textView.textColor = Colors.black
                textView.isScrollEnabled = false
                textView.translatesAutoresizingMaskIntoConstraints = true
            }
        }
    }
    
    @IBOutlet var animalImageView: UIImageView! {
        willSet {
            if let imageView: UIImageView = newValue {
                imageView.layer.shadowColor   = Colors.black.cgColor
                imageView.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                imageView.layer.shadowOpacity = 0.16
                imageView.layer.shadowRadius  = 8.0
            }
        }
    }
    
    @IBOutlet var shareButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setBackgroundImage(UIImage(named: "Share"), for: .normal)
                
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
                button.setBackgroundImage(UIImage(named: "More"), for: .normal)
                
                button.layer.shadowColor   = Colors.black.cgColor
                button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius  = 6.0
            }
        }
    }
    
    // MARK: View Initialization
    
    required init(sighting: Sighting) {
        self.sighting = sighting
        super.init(frame: .zero)
        self.commontInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commontInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commontInit()
    }
    
    private func commontInit() {
        contentView.backgroundColor = Colors.background
        
        setDetail(for: sighting)
    }
    
    // MARK: Button Actions
    
    @IBAction func dismissButtonAction() {
        guard let delegate = delegate else { return }
        delegate.showGameMap()
    }
    
    @IBAction func moreButtonAction() {
        guard let delegate = delegate, let animalInfoLink = animalInfoLink else { return }
        delegate.showAnimalInfo(animalInfoLink)
    }
    
    @IBAction func shareButtonAction() {
        guard let delegate = delegate else { return }
        delegate.showShareSheet(for: sighting.animal)
    }
    
    // MARK: Private Functions
    
    private func setDetail(for sighting: Sighting) {
        guard let animalName = sighting.animal.name,
              let animalDescription = sighting.animal.description,
              let animalInfoLink = sighting.animal.infoLink,
              let animalImage = UIImage(named: "hawk") else { return }
        
        setPoints(with: sighting.points)
        setAnimalName(with: animalName)
        setAnimalDescription(with: animalDescription)
        setAnimalImage(with: animalImage)
        
        self.animalInfoLink = animalInfoLink
    }
    
    private func setPoints(with value: Int) {
        let attributedText = NSMutableAttributedString.init(string: value == 1 ? "+\(value) point" : "+\(value) points")
        attributedText.setAttributes([NSAttributedString.Key.font: Fonts.bold.withSize(28.0)], range: NSMakeRange(0, "\(value)".count+1))
        attributedText.setAttributes([NSAttributedString.Key.baselineOffset: 2.0], range: NSMakeRange("\(value)".count, attributedText.length-1))

        pointsLabel.attributedText = attributedText
    }
    
    private func setAnimalName(with value: String) {
        animalNameLabel.text = value
    }
    
    private func setAnimalDescription(with value: String) {
        animalDescriptionTextView.text = value
        
        let fixedWidth = animalDescriptionTextView.frame.size.width-32
        animalDescriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = animalDescriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = animalDescriptionTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        animalDescriptionTextView.frame = newFrame
    }
    
    private func setAnimalImage(with value: UIImage) {
        animalImageView.image = value
    }
    
}

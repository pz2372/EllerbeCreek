//
//  SightingTableViewCell.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/19/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class SightingTableViewCell: UITableViewCell {
    
    @IBOutlet var animalImageView: UIImageView! {
        willSet {
            if let imageView: UIImageView = newValue {
                imageView.contentMode = .scaleAspectFit
                imageView.layer.shadowColor = Colors.black.cgColor
                imageView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                imageView.layer.shadowOpacity = 0.10
                imageView.layer.shadowRadius = 5.0
            }
        }
    }
    
    @IBOutlet var animalNameLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.adjustsFontSizeToFitWidth = true
                label.font = Fonts.semibold.withSize(22.0)
                label.numberOfLines = 2
                label.textAlignment = .left
                label.textColor = Colors.black
            }
        }
    }
    
    @IBOutlet var pointsLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.bold.withSize(32.0)
                label.textAlignment = .center
                label.textColor = Colors.black
            }
        }
    }
    
    @IBOutlet var pointsDescriptionLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.semibold.withSize(18.0)
                label.textAlignment = .center
                label.textColor = Colors.lightGreen
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        layer.shadowColor = Colors.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 6.0
        selectionStyle = .none
           
        if let backgroundView = backgroundView {
            backgroundView.backgroundColor = Colors.white
            backgroundView.layer.cornerRadius = 16.0
            backgroundView.layer.masksToBounds = true
        }
    }
    
}

// MARK: - Bounce Animation

extension SightingTableViewCell {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }
  
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
  
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
  
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)? = nil) {
        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        if isHighlighted {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: animationOptions, animations: {
                self.transform = .init(scaleX: 0.95, y: 0.95)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: animationOptions, animations: {
                self.transform = .identity
            }, completion: completion)
        }
    }
    
}


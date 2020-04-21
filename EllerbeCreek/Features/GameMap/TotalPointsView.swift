//
//  TotalPointsView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 4/15/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class TotalPointsView: NibBasedView {
    
    public weak var delegate: GameMapViewControllerDelegate?
    
    private var isTouched: Bool!
    
    @IBOutlet var textLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.adjustsFontSizeToFitWidth = true
                label.font = Fonts.heavy.withSize(48.0)
                label.text = "0"
                label.textAlignment = .center
                label.textColor = Colors.black
            }
        }
    }
    
    @IBOutlet var detailTextLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.adjustsFontSizeToFitWidth = true
                label.font = Fonts.semibold.withSize(22.0)
                label.text = "points"
                label.textAlignment = .center
                label.textColor = Colors.lightGreen
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
        layer.shadowColor = Colors.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 6.0
        
        isTouched = false
        
        styleContentView()
    }
    
    private func styleContentView() {
        contentView.backgroundColor = Colors.white
        contentView.layer.cornerRadius = 24.0
        contentView.layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isTouched {
            isTouched = true
            
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            })
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouched {
            isTouched = false
            
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouched {
            isTouched = false
            
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform.identity
            })
            
            guard let delegate = delegate else { return }
            delegate.showSessionDetailView()
        }
    }
    
}

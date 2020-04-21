//
//  SessionHeaderView.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/19/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class SessionHeaderView: NibBasedView {
    
    // MARK: Private Variables
    
    public var session: Session! {
        didSet {
            setInterfaceObjects()
        }
    }
    
    // MARK: Interface Objects
    
    @IBOutlet var totalPointsLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.semibold.withSize(24.0)
                label.textColor = Colors.black
            }
        }
    }
    
    @IBOutlet var preserveNameLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.bold.withSize(44.0)
                label.textAlignment = .left
                label.textColor = Colors.black
            }
        }
    }
    
    // MARK: View Initialization
    
    required init(session: Session, frame: CGRect) {
        super.init(frame: frame)
        self.session = session
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
        backgroundColor = .clear
        
    }
    
    // MARK: Private Functions
    
    private func setInterfaceObjects() {
        guard let preserveName = session.preserve.name else { return }
        
        setPoints(with: session.totalPoints)
        preserveNameLabel.text = "\(preserveName)"
    }
    
    private func setPoints(with value: Int) {
        let attributedText = NSMutableAttributedString.init(string: value == 1 ? "\(value) point" : "\(value) points")
        attributedText.setAttributes([NSAttributedString.Key.font: Fonts.bold.withSize(28.0)], range: NSMakeRange(0, "\(value)".count+1))
        attributedText.setAttributes([NSAttributedString.Key.baselineOffset: 2.0], range: NSMakeRange("\(value)".count, attributedText.length-1))

        totalPointsLabel.attributedText = attributedText
    }
    
}

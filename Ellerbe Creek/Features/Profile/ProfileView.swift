//
//  ProfileView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 4/7/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class ProfileView: NibBasedView {
    
    public weak var delegate: ProfileViewControllerDelegate?
    
    @IBOutlet var headerView: NavigationHeaderView!
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = Colors.background
        updateHeaderView(with: 12)
    }
    
    private func updateHeaderView(with value: Int) {
//        let headerText = NSMutableAttributedString.init(string: value == 1 ? "\(value) point" : "\(value) points")
//
//        // Adds a custom font and size for sightings value in the headerText string
//        headerText.setAttributes([NSAttributedString.Key.font: Fonts.bold.withSize(86.0)],
//                                 range: NSMakeRange(0, "\(value)".count))
//
//        // Vertically centers the 'sightings nearby' description following the sighting value in the headerText string
//        headerText.setAttributes([NSAttributedString.Key.baselineOffset: 20.0], range: NSMakeRange("\(value)".count, headerText.length-1))
//
//        headerView.mainLabel.attributedText = headerText
        headerView.mainLabel.text = "12 points"
    }
    
}

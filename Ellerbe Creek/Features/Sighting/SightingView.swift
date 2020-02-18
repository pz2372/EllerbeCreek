//
//  SightingView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/14/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class SightingView: NibBasedView {
    
    public weak var delegate: SightingViewControllerDelegate?
    
    @IBOutlet var dismissButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        
    }
    
    @IBAction func dismissButtonAction() {
        guard let delegate = delegate else { return }
        delegate.showGameMap()
    }
}

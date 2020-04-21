//
//  Fonts.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/4/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

struct Fonts {
    
    static let bold: UIFont = {
        return UIFont(name: "SFProRounded-Bold", size: UIFont.labelFontSize) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .bold)
    }()
    
    static let heavy: UIFont = {
        return UIFont(name: "SFProRounded-Heavy", size: UIFont.labelFontSize) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .heavy)
    }()
    
    static let regular: UIFont = {
        return UIFont(name: "SFProRounded-Regular", size: UIFont.labelFontSize) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .regular)
    }()
    
    static let semibold: UIFont = {
        return UIFont(name: "SFProRounded-Semibold", size: UIFont.labelFontSize) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .semibold)
    }()
    
}

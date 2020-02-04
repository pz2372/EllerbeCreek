//
//  MainNavigationController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/4/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        style()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    private func style() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Colors.darkGreen
            appearance.titleTextAttributes = [.foregroundColor: Colors.white,
                                              .font: Fonts.semibold.withSize(22.0)]
            
            // Removes shadow from bottom of the default navigationBar
            appearance.shadowColor = .clear
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
        } else {
            navigationBar.isTranslucent = false
            navigationBar.tintColor = Colors.darkGreen
            navigationBar.titleTextAttributes = [.foregroundColor: Colors.white,
                                                 .font: UIFont.systemFont(ofSize: 22.0, weight: .semibold)]
            
            // Removes shadow from bottom of the default navigationBar
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
        }

    }
    

}

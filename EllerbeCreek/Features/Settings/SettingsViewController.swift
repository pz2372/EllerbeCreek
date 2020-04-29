//
//  SettingsViewController.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/27/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func showProfile()
}

class SettingsViewController: UIViewController {
    
    private let navigator: SettingsNavigator
    private let storage: Storage
    private let settingsView: SettingsView = SettingsView()
    
    required init(navigator: SettingsNavigator) {
        self.navigator = navigator
        self.storage = navigator.dependencyContainer.storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.settingsView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

extension SettingsViewController: SettingsViewControllerDelegate {
    
    func showProfile() {
        dismiss(animated: true)
    }
    
}

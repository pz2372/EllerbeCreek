//
//  ProfileViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 4/7/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: class {
    
}

class ProfileViewController: UIViewController {
    
    // MARK - Constants
    
    private let navigator: ProfileNavigator
    private let storage: Storage
    private let profileView: ProfileView = ProfileView()
    
    // MARK - Variables
    
    private var dismissButton: UIBarButtonItem! {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 26.0, height: 26.0))
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(named: "Close-1"), for: .normal)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    private var settingsButton: UIBarButtonItem! {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 26.0, height: 26.0))
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(named: "Settings"), for: .normal)
        button.addTarget(self, action: #selector(settingsAction), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    private var isNewSessionViewPresented: Bool = false
    
    // MARK: - UIViewController Lifecycle
    
    required init(navigator: ProfileNavigator) {
        self.navigator = navigator
        self.storage = navigator.dependencyContainer.storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileView.delegate = self
        
        self.title = "andersonmryan"
        
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc private func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func settingsAction() {
        
    }
    
}

extension ProfileViewController: ProfileViewControllerDelegate {
    
    
    
}

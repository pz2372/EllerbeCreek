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
    
    private var gameMapButton: UIBarButtonItem! {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 36.0, height: 36.0))
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(named: "User"), for: .normal)
        button.addTarget(self, action: #selector(gameMapButtonAction), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    private var sessionButton: UIBarButtonItem! {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 36.0, height: 36.0))
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(named: "User"), for: .normal)
        button.addTarget(self, action: #selector(gameMapButtonAction), for: .touchUpInside)
        
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
        
        navigationItem.leftBarButtonItem = gameMapButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc private func gameMapButtonAction() {
        navigator.navigate(to: .gameMap)
    }
    
}

extension ProfileViewController: ProfileViewControllerDelegate {
    
    
    
}

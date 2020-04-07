//
//  UserSessionsViewController.swift
//  Ellerbe Creek
//
//  Created by Rob McCollough on 4/7/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//


import UIKit

protocol UserSessionsViewControllerDelegate: class {
    func showGameMap()
}

class UserSessionsViewController: UIViewController {
    
    // MARK - Constants

    private let navigator: UserSessionsNavigator
    private let storage: Storage
    private let UserSessionsView: UserSessionsView = UserSessionsView()

    // MARK - Variables

    // MARK: - UIViewController Lifecycle

    required init(navigator: UserSessionsNavigator) {
        self.navigator = navigator
        self.storage = navigator.dependencyContainer.storage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func loadView() {
        super.loadView()
        self.view = self.UserSessionsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.UserSessionsView.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

extension UserSessionsViewController: UserSessionsViewControllerDelegate {
    
    func showGameMap() {
        dismiss(animated: true, completion: nil)
    }
    
}


//
//  NewSessionViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/30/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

@objc protocol NewSessionViewControllerDelegate: AnyObject {
    func dismiss()
    func startNewSession()
    @objc optional func willDismiss()
}

class NewSessionViewController: UIViewController {
    
    // MARK - Constants

    private let navigator: NewSessionNavigator
    private let storage: Storage
    private let newSessionView: NewSessionView = NewSessionView()

    // MARK - Variables

    // MARK: - UIViewController Lifecycle

    required init(navigator: NewSessionNavigator) {
        self.navigator = navigator
        self.storage = navigator.dependencyContainer.storage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func loadView() {
        super.loadView()
        self.view = self.newSessionView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.newSessionView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

extension NewSessionViewController: NewSessionViewControllerDelegate {
    
    func dismiss() {
        dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "OnViewWillAppear"), object: nil)
    }
    
    func startNewSession() {
        dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "OnViewWillAppear"), object: nil)
    }
    
}

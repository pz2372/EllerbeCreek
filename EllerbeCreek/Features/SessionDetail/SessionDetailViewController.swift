//
//  SessionDetailViewController.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/19/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

protocol SessionDetailViewControllerDelegate: class {
    func showProfile()
    func showSightingDetail(sighting: Sighting)
}

class SessionDetailViewController: UIViewController {
    
    // MARK - Constants
    
    private let navigator: SessionDetailNavigator
    private let storage: Storage
    private let sessionDetailView: SessionDetailView
    
    // MARK: - UIViewController Lifecycle
    
    required init(navigator: SessionDetailNavigator, session: Session) {
        self.navigator = navigator
        self.storage = navigator.dependencyContainer.storage
        self.sessionDetailView = SessionDetailView(session: session)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.sessionDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sessionDetailView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension SessionDetailViewController: SessionDetailViewControllerDelegate {
    
    func showProfile() {
        dismiss(animated: true)
    }
    
    func showSightingDetail(sighting: Sighting) {
        navigator.present(.sightingDetail(sighting), with: .currentContext)
    }
    
}

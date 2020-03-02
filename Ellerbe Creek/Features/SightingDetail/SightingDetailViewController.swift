//
//  SightingDetailViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/24/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

protocol SightingDetailViewControllerDelegate: class {
    func showGameMap()
}

class SightingDetailViewController: UIViewController {
    
    // MARK - Constants

    private let navigator: SightingDetailNavigator
    private let storage: Storage
    private let sightingDetailView: SightingDetailView = SightingDetailView()

    // MARK - Variables

    // MARK: - UIViewController Lifecycle

    required init(navigator: SightingDetailNavigator) {
        self.navigator = navigator
        self.storage = navigator.dependencyContainer.storage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func loadView() {
        super.loadView()
        self.view = self.sightingDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sightingDetailView.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

extension SightingDetailViewController: SightingDetailViewControllerDelegate {
    
    func showGameMap() {
        dismiss(animated: true, completion: nil)
    }
    
}

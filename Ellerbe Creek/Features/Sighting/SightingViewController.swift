//
//  SightingViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/14/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

protocol SightingViewControllerDelegate: class {
    func presentSightingDetail()
    func showGameMap()
}

class SightingViewController: UIViewController, NibLoadable {

    // MARK - Constants

    private let navigator: SightingNavigator
    private let storage: Storage
    private let sightingView: SightingView = SightingView()

    // MARK - Variables

    // MARK: - UIViewController Lifecycle

    required init(navigator: SightingNavigator) {
        self.navigator = navigator
        self.storage = navigator.dependencyContainer.storage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func loadView() {
        super.loadView()
        self.view = self.sightingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sightingView.delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}

extension SightingViewController: SightingViewControllerDelegate {
    
    func presentSightingDetail() {
        
    }
    
    func showGameMap() {
        dismiss(animated: true, completion: nil)
    }
    
}

//
//  SightingViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/14/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

protocol SightingViewControllerDelegate: class {
    func showSightingDetail(for sighting: Sighting)
    func showGameMap()
}

class SightingViewController: UIViewController, NibLoadable {

    // MARK - Constants

    private let navigator: SightingNavigator
    private let storage: Storage
    private let sightingView: SightingView

    // MARK: - UIViewController Lifecycle

    required init(navigator: SightingNavigator, sighting: Sighting) {
        self.navigator = navigator
        self.storage = navigator.dependencyContainer.storage
        self.sightingView = SightingView(sighting: sighting)
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
    
    func showSightingDetail(for sighting: Sighting) {
        dismiss(animated: true, completion: nil)
        navigator.present(.sightingDetail(sighting))
    }
    
    func showGameMap() {
        dismiss(animated: true, completion: nil)
    }
    
}

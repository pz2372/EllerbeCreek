//
//  GameMapViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/3/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

protocol GameMapViewControllerDelegate: class {
    
}

class GameMapViewController: UIViewController, NibLoadable {
    
    // MARK - Constants
    
    private let navigator: GameMapNavigator
    private let storage: Storage
    private let gameMapView: GameMapView = GameMapView()
    
    // MARK: - UIViewController Lifecycle
    
    required init(navigator: GameMapNavigator) {
        self.navigator = navigator
        self.storage = navigator.dependencyContainer.storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.gameMapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.gameMapView.delegate = self
    }

}

extension GameMapViewController: GameMapViewControllerDelegate {
    
}

//
//  SightingDetailViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/24/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import SafariServices

protocol SightingDetailViewControllerDelegate: class {
    func showGameMap()
    func showAnimalInfo(_ infoLink: String)
    func showShareSheet(for animal: Animal)
}

class SightingDetailViewController: UIViewController {
    
    // MARK - Constants

    private let navigator: SightingDetailNavigator
    private let storage: Storage
    private let sightingDetailView: SightingDetailView

    // MARK: - UIViewController Lifecycle

    required init(navigator: SightingDetailNavigator, sighting: Sighting) {
        self.navigator = navigator
        self.storage = navigator.dependencyContainer.storage
        self.sightingDetailView = SightingDetailView(sighting: sighting)
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension SightingDetailViewController: SightingDetailViewControllerDelegate {
    
    func showGameMap() {
        dismiss(animated: true, completion: nil)
    }
    
    func showAnimalInfo(_ infoLink: String) {
        if let url = URL(string: infoLink) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    func showShareSheet(for animal: Animal) {
        guard let animalName = animal.name,
              let animalInfoLink = animal.infoLink else { return }
        let items: [Any] = ["I saw a \(animalName) at an Ellerbe Creek Preserve! Download the Ellerbe Creek app today to see for yourself.", URL(string: animalInfoLink)!]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.modalPresentationStyle = .currentContext
        present(activityController, animated: true)
    }
    
}

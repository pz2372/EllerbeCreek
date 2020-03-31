//
//  GameMapViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/3/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import CoreLocation

protocol GameMapViewControllerDelegate: class {
    func checkForPreserves(near userLocation: CLLocation) -> Preserve?
    func presentSighting()
}

class GameMapViewController: UIViewController, NibLoadable {
    
    // MARK - Constants
    
    private let navigator: GameMapNavigator
    private let storage: Storage
    private let gameMapView: GameMapView = GameMapView()
    private let nearbyPreserveRadius = 1610.0
    
    // MARK - Variables
    
    private var profileButton: UIBarButtonItem! {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 36.0, height: 36.0))
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(named: "User"), for: .normal)
        button.addTarget(self, action: #selector(profileButtonAction), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    private var isNewSessionViewPresented: Bool = false
    
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
        
        self.title = "Find a Preserve"
        
        navigationItem.leftBarButtonItem = profileButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentNavigationBar), name: Notification.Name(rawValue: "OnViewWillAppear"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc private func profileButtonAction() {
        let alertController = UIAlertController(title: "User", message: "\(GCHelper.sharedInstance.getLocalUser())", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func presentNavigationBar() {
        isNewSessionViewPresented = false
        
        guard let navigationController = navigationController else { return }
        navigationController.setNavigationBarHidden(false, animated: true)
        
        self.gameMapView.headerViewTopConstraint.constant = 0.0
        self.gameMapView.setNeedsUpdateConstraints()
        UIView.animate(withDuration: TimeInterval(UINavigationController.hideShowBarDuration), animations: {
            self.gameMapView.layoutIfNeeded()
        })
    }
    
    private func dismissNavigationBar(_ animated: Bool = true) {
        guard let navigationController = navigationController else { return }
        navigationController.setNavigationBarHidden(true, animated: animated)
        
        self.gameMapView.headerViewTopConstraint.constant = self.gameMapView.headerViewHeightConstraint.constant*2
        self.gameMapView.setNeedsUpdateConstraints()
        UIView.animate(withDuration: TimeInterval(UINavigationController.hideShowBarDuration), animations: {
            self.gameMapView.layoutIfNeeded()
        })
    }

}

extension GameMapViewController: GameMapViewControllerDelegate {
    
    func checkForPreserves(near userLocation: CLLocation) -> Preserve? {
        if let preserves = DatabaseManager.shared.loadData(from: .preserves) as? [Preserve] {
            if !preserves.isEmpty {
                for preserve in preserves {
                    let preserveLocation = CLLocation(latitude: preserve.center[0], longitude: preserve.center[1])
                    let distance = userLocation.distance(from: preserveLocation)
                    
                    if distance < nearbyPreserveRadius {
                        if !isNewSessionViewPresented {
                            isNewSessionViewPresented = true
                            
                            storage.set(value: preserve, forKey: .currentPreserve)
                            navigator.present(.profile, with: .overCurrentContext)
                        }
                        
                        self.title = preserve.name + " Preserve"
                        return preserve
                    } else {
                        self.title = "Find a Preserve"
                    }
                }
            }
        }
        
        return nil
    }
    
    func presentSighting() {
        navigator.present(.sighting)
    }
    
}

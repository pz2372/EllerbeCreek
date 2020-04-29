//
//  GameMapViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/3/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

protocol GameMapViewControllerDelegate: class {
    func isAtPreserve(_ userLocation: CLLocation, completion: (Bool) -> ())
    func showSightingView(with sighting: Sighting)
    func showSessionDetailView()
    func sessionEnded()
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
    
    private var sessionButton: UIBarButtonItem! {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 26.0, height: 26.0))
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(named: SessionManager.shared.isSessionInProgress ? "Stop" : "Play"), for: .normal)
        button.addTarget(self, action: #selector(sessionButtonAction), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    private var hasNewSessionViewBeenPresented: Bool = false
    
    private var currentPreserve: Preserve? = nil
    
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
        navigator.present(.profile)
    }
    
    @objc private func sessionButtonAction() {
        if SessionManager.shared.isSessionInProgress {
            SessionManager.shared.end()
            
            navigationItem.leftBarButtonItem = profileButton
            navigationItem.rightBarButtonItem = currentPreserve == nil ? nil : sessionButton
        } else {
            if let preserve = currentPreserve {
                dismissNavigationBar()
                navigator.present(.newSession(preserve), with: .overCurrentContext)
            }
        }
    }
    
    @objc private func presentNavigationBar() {
        if SessionManager.shared.isSessionInProgress {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = sessionButton
        } else {
            navigationItem.leftBarButtonItem = profileButton
            navigationItem.rightBarButtonItem = sessionButton
        }
        
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
    
    func isAtPreserve(_ userLocation: CLLocation, completion: (Bool) -> ()) {
        DatabaseManager.preserves.fetch { (data, error) in
            if let preserves = data as? [Preserve] {
                for preserve in preserves {
                    guard let preserveCenter = preserve.center,
                          let preserveName = preserve.name else { return }
                    
                    let preserveLocation = preserveCenter.location
                    let distance = userLocation.distance(from: preserveLocation)
                    
                    if distance < nearbyPreserveRadius {
                        if currentPreserve == nil && !SessionManager.shared.isSessionInProgress {
                            currentPreserve = preserve
                            
                            dismissNavigationBar()
                            
                            navigator.present(.newSession(preserve), with: .overCurrentContext)
                        }
                        
                        self.title = preserveName + " Preserve"
                        completion(true)
                    } else {
                        self.title = "Find a Preserve"
                        currentPreserve = nil
                        navigationItem.rightBarButtonItem = nil
                        completion(false)
                    }
                }
            } else if let error = error {
                print(error)
                currentPreserve = nil
                navigationItem.rightBarButtonItem = nil
                completion(false)
            }
        }
    }
    
    func showSightingView(with sighting: Sighting) {
        navigator.present(.sighting(sighting))
    }
    
    func showSessionDetailView() {
        if let session =  SessionManager.shared.session {
            navigator.present(.sessionDetail(session), with: .overCurrentContext)
        }
    }
    
    func sessionEnded() {
        navigationItem.rightBarButtonItem = sessionButton
    }
    
}

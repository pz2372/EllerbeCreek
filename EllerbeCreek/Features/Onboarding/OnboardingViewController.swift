//
//  OnboardingViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/22/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate: class {
    func onboarding(completed: Bool)
}

class OnboardingViewController: UIViewController {
    
    // MARK - Constants
    
    private let navigator: OnboardingNavigator
    private let storage: Storage
    private let onboardingView: OnboardingView = OnboardingView()
    private let nearbyPreserveRadius = 1610.0
    
    // MARK: - UIViewController Lifecycle
    
    required init(navigator: OnboardingNavigator) {
        self.navigator = navigator
        self.storage = navigator.dependencyContainer.storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.onboardingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.onboardingView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

extension OnboardingViewController: OnboardingViewControllerDelegate {
    
    func onboarding(completed: Bool) {
        if completed {
            UserDefaults.standard.set(true, forKey: "ONBOARDING_COMPLETED")
            
            navigator.navigate(to: .gameMap)
        }
    }
    
}

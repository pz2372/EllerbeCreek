//
//  DependencyContainer.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/4/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

// Defines the core state/behavior of the dependency container that every Navigator will need access to
typealias CoreDependencyContainer = SystemNavigatable & ViewControllerFactory


class DependencyContainer: CoreDependencyContainer, KeyValueStorable {
    // When possible, make all properties lazy to avoid circular dependencies and allow to be created in any order
    
    // MARK: - SystemNavigatable
    let navigationController = MainNavigationController()

    let profileNavigationController = MainNavigationController()
    
    // MARK: - KeyValueStorable
    lazy var storage = Storage()
    
    // MARK: - ViewControllerFactory
    func makeGameMapViewController() -> GameMapViewController {
        return GameMapViewController(navigator: GameMapNavigator(dependencyContainer: self))
    }
    
    func makeSightingViewController(sighting: Sighting) -> SightingViewController {
        return SightingViewController(navigator: SightingNavigator(dependencyContainer: self), sighting: sighting)
    }
    
    func makeSightingDetailViewController(sighting: Sighting) -> SightingDetailViewController {
        return SightingDetailViewController(navigator: SightingDetailNavigator(dependencyContainer: self), sighting: sighting)
    }
    
    func makeOnboardingViewController() -> OnboardingViewController {
        return OnboardingViewController(navigator: OnboardingNavigator(dependencyContainer: self))
    }
    
    func makeNewSessionViewController(preserve: Preserve) -> NewSessionViewController {
        return NewSessionViewController(navigator: NewSessionNavigator(dependencyContainer: self), preserve: preserve)
    }
    
    func makeProfileViewController() -> ProfileViewController {
        return ProfileViewController(navigator: ProfileNavigator(dependencyContainer: self))
    }
    
    func makeSessionDetailViewController(session: Session) -> SessionDetailViewController {
        return SessionDetailViewController(navigator: SessionDetailNavigator(dependencyContainer: self), session: session)
    }
    
}


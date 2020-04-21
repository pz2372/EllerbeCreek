//
//  ViewControllerFactory.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/4/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

protocol ViewControllerFactory {
    func makeGameMapViewController() -> GameMapViewController
    func makeSightingViewController(sighting: Sighting) -> SightingViewController
    func makeSightingDetailViewController(sighting: Sighting) -> SightingDetailViewController
    func makeOnboardingViewController() -> OnboardingViewController
    func makeNewSessionViewController(preserve: Preserve) -> NewSessionViewController
    func makeProfileViewController() -> ProfileViewController
    func makeSessionDetailViewController(session: Session) -> SessionDetailViewController
}

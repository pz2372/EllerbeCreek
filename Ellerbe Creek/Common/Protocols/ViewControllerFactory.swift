//
//  ViewControllerFactory.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/4/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

protocol ViewControllerFactory {
    func makeGameMapViewController() -> GameMapViewController
    func makeSightingViewController() -> SightingViewController
    func makeSightingDetailViewController() -> SightingDetailViewController
    func makeOnboardingViewController() -> OnboardingViewController
}

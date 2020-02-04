//
//  Navigator.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/4/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

protocol Navigator {
    associatedtype Destination
    
    func navigate(to destination: Destination)
}

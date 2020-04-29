//
//  ARAnimals.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/27/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation

struct ARAnimals {
    
    static let animals: [ARAnimal] = [frog, duck, fish, beaver]
    
    static let frog: ARAnimal = {
        return ARAnimal(name: "frog", type: .amphibian)
    }()
    
    static let duck: ARAnimal = {
        return ARAnimal(name: "duck", type: .bird)
    }()
    
    static let fish: ARAnimal = {
        return ARAnimal(name: "fish", type: .fish)
    }()
    
    static let beaver: ARAnimal = {
        return ARAnimal(name: "beaver", type: .mammal)
    }()
    
}

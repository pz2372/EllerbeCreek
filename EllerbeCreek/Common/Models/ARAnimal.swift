//
//  ARAnimal.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/27/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation

struct ARAnimal {
    var name: String
    var type: AnimalType
    
    var assetPath: String {
        return "Assets.scnassets/\(name)/\(name).dae"
    }
}

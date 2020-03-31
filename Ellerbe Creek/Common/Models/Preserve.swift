//
//  Preserve.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/5/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import AnyCodable

struct Preserve: Codable {
    var id: Int = Int()
    var name: String = ""
    var center: [Double] = [Double]()
    var bounds: [String:[Double]] = [String:[Double]]()
    var animals: [AnyCodable] = [AnyCodable]()
}

//
//  SightingPointAnnotation.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 4/13/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Mapbox

class SightingPointAnnotation: MGLPointAnnotation {
    
    var sighting: Sighting!
    
    init(sighting: Sighting) {
        super.init()
        
        self.sighting = sighting
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

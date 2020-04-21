//
//  Cells.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/19/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation

struct Cells {
    
    struct Session {
        static let id: String = {
           return "CELLS_IDENTIFIERS_SESSION"
        }()
        
        static let name: String = {
            return "SessionTableViewCell"
        }()
    }
    
    struct Sighting {
        static let id: String = {
           return "CELLS_IDENTIFIERS_SIGHTING"
        }()
        
        static let name: String = {
            return "SightingTableViewCell"
        }()
    }
  
}

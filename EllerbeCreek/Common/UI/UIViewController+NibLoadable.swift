//
//  UIViewController+NibLoadable.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/4/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

public protocol NibLoadable {
    static func nibNameAndBundle() -> (String, Bundle)
}

public extension NibLoadable where Self: UIViewController {
    
    static func nibNameAndBundle() -> (String, Bundle) {
        
        let bundle = Bundle(for: Self.self)
        
        // note: nib file must have the same name as the view controller class
        let nibName = (String(describing: type(of: self)) as NSString).components(separatedBy: ".").first!
        
        return (nibName, bundle)
    }
}

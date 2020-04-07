//
//  UserSessionsView.swift
//  Ellerbe Creek
//
//  Created by Rob McCollough on 4/7/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class UserSessionsView: NibBasedView {
    
    public weak var delegate: UserSessionsViewControllerDelegate?
    
    @IBOutlet var dismissButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setImage(UIImage(named: "Close"), for: .normal)
                
                button.layer.shadowColor   = Colors.black.cgColor
                button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius  = 6.0
            }
        }
    }
    
    @IBOutlet var sessionsView: UITableView! {
        willSet {
            if let sessionsView: UITableView = newValue {
                sessionsView.layer.shadowColor   = Colors.black.cgColor
                sessionsView.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                sessionsView.layer.shadowOpacity = 0.16
                sessionsView.layer.shadowRadius  = 10.0
            }
        }
    }
    
//    @IBOutlet var pointsLabel: UILabel! {
//        willSet {
//            if let label: UILabel = newValue {
//                label.textAlignment = .right
//                label.font = Fonts.semibold.withSize(24.0)
//            }
//        }
//    }
    
//    @IBOutlet var nameLabel: UILabel! {
//        willSet {
//            if let label: UILabel = newValue {
//                label.textAlignment = .left
//                label.font = Fonts.semibold.withSize(24.0)
//            }
//        }
//    }
    
    
    
//     @IBOutlet var shareButton: UIButton! {
//           willSet {
//               if let button: UIButton = newValue {
//                   button.setTitle("", for: .normal)
//                   button.setImage(UIImage(named: "Share"), for: .normal)
//
//                   button.layer.shadowColor   = Colors.black.cgColor
//                   button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
//                   button.layer.shadowOpacity = 0.1
//                   button.layer.shadowRadius  = 6.0
//               }
//           }
//       }
    
    //var sessions = Session(date: '04/04/20', preserve: 'Beaver Marsh', animals: [])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUp()
    }
    
    private func setUp() {
        //TODO: Populate TableView with session objects
        contentView.backgroundColor = Colors.background
        
//       setSessions(with: sessions)
    }
    
    @IBAction func dismissButtonAction() {
        guard let delegate = delegate else { return }
        delegate.showGameMap()
    }
    
    private func setSessions(with value: Int) {
//        let nameText = NSMutableAttributedString.init(string: value == 1 ? "+\(value) point" : "+\(value) points")
//
//        // Adds a custom font and size for sightings value in the headerText string
//        nameText.setAttributes([NSAttributedString.Key.font: Fonts.bold.withSize(28.0)],
//                                 range: NSMakeRange(0, "\(value)".count+1))
//
//        // Vertically centers the 'sightings nearby' description following the sighting value in the headerText string
//        nameText.setAttributes([NSAttributedString.Key.baselineOffset: 2.0], range: NSMakeRange("\(value)".count, nameText.length-1))
//
//        pointsLabel.attributedText = nameText
    }
    
}

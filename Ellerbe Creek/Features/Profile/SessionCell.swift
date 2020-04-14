//
//  SessionCell.swift
//  Ellerbe Creek
//
//  Created by Rob McCollough on 4/14/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation
import UIKit

class SessionCell: UITableViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //todo
    //add image view
    
    let preserveLabel: UILabel = {
        let label = UILabel()
        label.text = "Beaver Marsh"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.text = "4/14/20"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12 points"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupView() {
        addSubview(cellView)
        cellView.addSubview(preserveLabel)
        cellView.addSubview(pointsLabel)
        cellView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        preserveLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        preserveLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        preserveLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        preserveLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        
        dateLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: cellView.centerXAnchor, constant: 20).isActive = true

        pointsLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        pointsLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        pointsLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        pointsLabel.leftAnchor.constraint(equalTo: cellView.rightAnchor, constant: 20).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

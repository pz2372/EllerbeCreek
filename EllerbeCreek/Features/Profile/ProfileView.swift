//
//  ProfileView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 4/7/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class ProfileView: NibBasedView {
    
    public weak var delegate: ProfileViewControllerDelegate?
    
    @IBOutlet var headerView: NavigationHeaderView! {
        willSet {
            if let view: NavigationHeaderView = newValue {
                view.textLabel.font = Fonts.bold.withSize(86.0)
                view.detailTextLabel.adjustsFontSizeToFitWidth = true
                view.detailTextLabel.font = Fonts.semibold.withSize(24.0)
                view.detailTextLabel.numberOfLines = 2
                view.detailTextLabelWidthConstraint.isActive = true
            }
        }
    }
    
    @IBOutlet var tableView: UITableView! {
        willSet {
            if let tableView: UITableView = newValue {
                tableView.backgroundColor = .clear
                tableView.delegate = self
                tableView.dataSource = self
                tableView.separatorStyle = .none
                tableView.showsVerticalScrollIndicator = true
                
                let sessionTableViewCell = UINib(nibName: Cells.Session.name, bundle: nil)
                tableView.register(sessionTableViewCell, forCellReuseIdentifier: Cells.Session.id)
                
                let labelFrame = CGRect(x: 16.0, y: 0.0, width: tableView.bounds.width-32.0, height: 48.0)
                let headerLabel = UILabel(frame: labelFrame)
                headerLabel.font = Fonts.semibold.withSize(24.0)
                headerLabel.text = "Recent Activity"
                headerLabel.textAlignment = .left
                headerLabel.textColor = Colors.black

                let viewFrame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 48.0)
                let headerView = UIView(frame: viewFrame)
                headerView.addSubview(headerLabel)
                
                tableView.tableHeaderView = headerView
            }
        }
    }
    
    private let dateFormatter = DateFormatter()
    private var user: User?
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = Colors.background
        user = DatabaseManager.users.fetchLocalUser()
        updateHeaderView(with: getTotalPoints())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 40.0, left: 0.0, bottom: 8.0, right: 0.0)
    }
    
    private func updateHeaderView(with value: Int) {
        let detailText = value == 1 ? "total\npoint" : "total\npoints"
        headerView.detailTextLabel.text = detailText
        headerView.textLabel.text = "\(value)"
    }
    
    private func getTimeSince(date: Date) -> String {
        if let minutes = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute, minutes < 60 {
            return "\(minutes) min ago"
        } else if let hours = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour, hours < 24 {
            return "\(hours) \(hours == 1 ? "hr" : "hrs") ago"
        } else if let days = Calendar.current.dateComponents([.day], from: date, to: Date()).day, days > 0, days < 7 {
            return "\(days) \(days == 1 ? "day" : "days") ago"
        } else {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "MMMM"
            let month = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "dd"
            let day = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "yyyy"
            let year = dateFormatter.string(from: date)
                
            return "\(month) \(day), \(year)"
        }
    }
    
    private func getTotalPoints() -> Int {
        guard let user = user else { return 0 }
        return user.sessions.map({$0.totalPoints}).reduce(0,+)
    }
    
}

extension ProfileView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = user else { return 0}
        return user.sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.Session.id) as! SessionTableViewCell
        guard let user = user else { return cell }
        let index = indexPath.row
        let session = user.sessions.sorted(by: { $0.date.compare($1.date) == .orderedDescending })[index]
        
        cell.preserveNameLabel.text = session.preserve.name ?? "Preserve"
        cell.timeSinceLabel.text = getTimeSince(date: session.date)
        cell.pointsLabel.text = "+\(session.totalPoints)"
        cell.pointsDescriptionLabel.text = session.totalPoints == 1 ? "point" : "points"
        
        return cell
    }
    
}

extension ProfileView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = user, let delegate = delegate else { return }
        let index = indexPath.row
        let session = user.sessions.sorted(by: { $0.date.compare($1.date) == .orderedDescending })[index]
        delegate.showSessionDetail(session: session)
    }
    
}

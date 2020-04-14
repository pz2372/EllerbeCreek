//
//  ProfileViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 4/7/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: class {
    
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    // MARK - Constants
    
    private let navigator: ProfileNavigator
    private let storage: Storage
    private let profileView: ProfileView = ProfileView()
    private let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK - Variables
    
    private var dismissButton: UIBarButtonItem! {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 26.0, height: 26.0))
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(named: "Close-1"), for: .normal)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    private var settingsButton: UIBarButtonItem! {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 26.0, height: 26.0))
        button.setTitle("", for: .normal)
        button.setBackgroundImage(UIImage(named: "Settings"), for: .normal)
        button.addTarget(self, action: #selector(settingsAction), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    private var isNewSessionViewPresented: Bool = false
    
    // MARK: - UIViewController Lifecycle
    
    required init(navigator: ProfileNavigator) {
        self.navigator = navigator
        self.storage = navigator.dependencyContainer.storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileView.delegate = self
        
        //TODO: fetch profile object from db
        
        self.title = "andersonmryan"
        
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = settingsButton
        setupTableView()
    }
    
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(SessionCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SessionCell
        cell.backgroundColor = UIColor.white
        
        //MARK data fetch for cells happens here
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc private func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func settingsAction() {
        
    }
    
}

extension ProfileViewController: ProfileViewControllerDelegate {
    
    
    
}

//
//  ProfileViewController.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 4/7/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: class {
    func showSessionDetail(session: Session)
}

class ProfileViewController: UIViewController {
    
    // MARK - Constants
    
    private let navigator: ProfileNavigator
    private let storage: Storage
    private let profileView: ProfileView = ProfileView()
    private let transition: PopAnimator = PopAnimator()
    
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
        
        self.title = "Profile"
        
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = settingsButton
        
        transition.dismissCompletion = { [weak self] in
            guard let self = self else { return }
            guard let selectedIndexPathCell = self.profileView.tableView.indexPathForSelectedRow,
                  let selectedCell = self.profileView.tableView.cellForRow(at: selectedIndexPathCell) as? SessionTableViewCell else { return }
          
            selectedCell.layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = DatabaseManager.users.fetchLocalUser() {
            self.title = user.displayName
        }
    
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc private func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func settingsAction() {
        navigator.present(.settings, with: .overCurrentContext)
    }
    
}

extension ProfileViewController: ProfileViewControllerDelegate {
    
    func showSessionDetail(session: Session) {
        navigator.present(.sessionDetail(session, self), with: .custom)
    }
    
}

extension ProfileViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let selectedIndexPathCell = profileView.tableView.indexPathForSelectedRow,
              let selectedCell = profileView.tableView.cellForRow(at: selectedIndexPathCell) as? SessionTableViewCell,
              let selectedCellSuperview = selectedCell.superview else { return nil }
          
        transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
//        transition.originFrame = CGRect(x: transition.originFrame.origin.x + 20, y: transition.originFrame.origin.y + 20, width: transition.originFrame.size.width - 40, height: transition.originFrame.size.height - 40)
          
        transition.isPresenting = true
        selectedCell.layer.shadowColor = UIColor.clear.cgColor
          
        return transition
    }
        
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

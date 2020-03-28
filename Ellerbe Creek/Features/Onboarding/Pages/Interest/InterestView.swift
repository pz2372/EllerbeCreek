//
//  InterestView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/22/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class InterestView: NibBasedView {
    
    public weak var delegate: OnboardingViewDelegate?
    
    @IBOutlet var subHeaderLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.semibold.withSize(24.0)
                label.textColor = Colors.black
            }
        }
    }
       
    @IBOutlet var headerLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.bold.withSize(48.0)
                label.textColor = Colors.darkGreen
            }
        }
    }
    
    @IBOutlet var emailDescriptionLabel: UILabel! {
        willSet {
            if let label: UILabel = newValue {
                label.font = Fonts.regular.withSize(16.0)
                label.numberOfLines = .max
                label.textColor = Colors.black
                label.textAlignment = .center
                label.text = "Enter your email below if you wish to stay\nup-to-date on news and events happening across our preserves."
            }
        }
    }
    
    @IBOutlet var emailTextField: UITextField! {
        willSet {
            if let textField: UITextField = newValue {
                textField.delegate = self
                textField.font = Fonts.semibold.withSize(20.0)
                textField.textColor = Colors.black
                textField.backgroundColor = Colors.white
                textField.borderStyle = .none
                textField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: Colors.lightGreen])
                textField.layer.cornerRadius = 12.0
                textField.layer.masksToBounds = true
                
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
                textField.leftView = paddingView
                textField.leftViewMode = .always
                
                textField.addTarget(self, action: #selector(keyboardWillShow), for: .editingChanged)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
           
        setUp()
    }
       
    required init?(coder: NSCoder) {
        super.init(coder: coder)
           
        setUp()
    }
    
    private func setUp() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldDidChange(textField:)))
        addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if frame.origin.y == 0 {
            frame.origin.y -= 100.0
        }
    }
    
    @objc func keyboardWillShow() {
        if frame.origin.y == 0 {
            frame.origin.y -= 100.0
        }
    }
    
    @objc func keyboardWillHide() {
        if frame.origin.y != 0 {
            frame.origin.y += 100.0
        }
    }
    
    
}

extension InterestView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//
//  OnboardingView.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/22/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

protocol OnboardingViewDelegate: class {
    func triggerScrollToNextSlide()
    func triggerScrollToPreviousSlide()
}

class OnboardingView: NibBasedView {
    
    @IBOutlet var scrollView: UIScrollView! {
        willSet {
            if let scrollView: UIScrollView = newValue {
                scrollView.delegate = self
                scrollView.isScrollEnabled = false
            }
        }
    }
    
    @IBOutlet var backButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitleColor(Colors.black, for: .normal)
                button.titleLabel?.font = Fonts.semibold.withSize(20)
                button.setTitle("Back", for: .normal)
            }
        }
    }
    
    @IBOutlet var navButton: UIButton! {
        willSet {
            if let button: UIButton = newValue {
                button.setTitle("", for: .normal)
                button.setBackgroundImage(UIImage(named: "Next"), for: .normal)
                
                button.layer.shadowColor   = Colors.black.cgColor
                button.layer.shadowOffset  = CGSize(width: 0.0, height: 2.0)
                button.layer.shadowOpacity = 0.1
                button.layer.shadowRadius  = 6.0
            }
        }
    }

    
    public weak var delegate: OnboardingViewControllerDelegate?
    
    private var currentSlide: Int = 0
    private var slides: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
          
        setUp()
    }
      
    required init?(coder: NSCoder) {
        super.init(coder: coder)
          
        setUp()
    }
   
    private func setUp() {
        scrollView.backgroundColor = Colors.background
        
        backButton.isHidden = true
        backButton.alpha = 0.0
        
        currentSlide = 0
        slides = createSlides()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupScrollView(with: slides)
    }
    
    private func setupScrollView(with slides: [UIView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        scrollView.contentSize = CGSize(width: frame.width * CGFloat(slides.count), height: frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: frame.width * CGFloat(i), y: 0, width: frame.width, height: frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    private func createSlides() -> [UIView] {
        let welcomeView = WelcomeView(), userCreationView = UserCreationView(), permissionsView = PermissionsView(), interestView = InterestView()
        welcomeView.delegate = self
        userCreationView.delegate = self
        permissionsView.delegate = self
        interestView.delegate = self
        
        return [welcomeView, userCreationView, permissionsView, interestView]
    }
    
    @IBAction func scrollToNextSlide() {
        nextSlide()
    }
    
    @IBAction func scrollToPreviousSlide() {
        previousSlide()
    }
    
    private func previousSlide() {
        let previousIndex = currentSlide - 1
        guard previousIndex > -1 else { return }
        
        navButton.setBackgroundImage(UIImage(named: "Next"), for: .normal)
        
        let slideRect = CGRect(x: frame.width * CGFloat(previousIndex), y: 0, width: frame.width, height: frame.height)
        scrollView.scrollRectToVisible(slideRect, animated: true)
    }
    
    private func nextSlide() {
        let nextIndex = currentSlide + 1
        guard nextIndex < slides.count else {
            guard let delegate = delegate else { return }
//            DatabaseManager.shared.fetchData(from: .preserves)
            delegate.onboarding(completed: true)
            
            return
        }
        
        if nextIndex == slides.count - 1 {
            navButton.setBackgroundImage(UIImage(named: "Done"), for: .normal)
        }
        
        let slideRect = CGRect(x: frame.width * CGFloat(nextIndex), y: 0, width: frame.width, height: frame.height)
        scrollView.scrollRectToVisible(slideRect, animated: true)
    }
    
}

extension OnboardingView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/frame.width)
        currentSlide = Int(pageIndex)
        
//        if currentSlide == 0 {
//            UIView.animate(withDuration: 1.0, animations: {
//                self.backButton.alpha = 0.0
//                self.backButton.isHidden = true
//            })
//        } else {
//            UIView.animate(withDuration: 1.0, animations: {
//                self.backButton.isHidden = false
//                self.backButton.alpha = 1.0
//            })
//        }
    }
    
}

extension OnboardingView: OnboardingViewDelegate {
    
    func triggerScrollToPreviousSlide() {
        scrollToPreviousSlide()
    }
    
    func triggerScrollToNextSlide() {
        scrollToNextSlide()
    }
    
}

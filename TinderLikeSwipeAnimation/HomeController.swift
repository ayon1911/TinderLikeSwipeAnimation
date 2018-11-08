//
//  ViewController.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 07.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    //MARK:- variables
    let topNavigationStackView = TopNavigationStackView()
    let bottomStackView = HomeBottomControlsStackView()
    let cardDeckView = UIView()
    
    let users = [
        User.init(name: "Gambit", age: 34, profession: "Card Strickstar", imageName: "gambit"),
        User.init(name: "Logan", age: 100, profession: "Army Person", imageName: "logan"),
        User.init(name: "Perter", age: 32, profession: "Camera Man", imageName: "peter"),
        User.init(name: "Berry", age: 25, profession: "Student", imageName: "flash"),
        User.init(name: "Deadpool", age: 45, profession: "Idiocracy", imageName: "deadpool"),
        User.init(name: "Bruce Wayne", age: 60, profession: "Billionaire", imageName: "batman"),
        User.init(name: "Dr.Strange", age: 42, profession: "Doctor", imageName: "strange")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupMainStackView()
        setupCardView()
    }

    //MARK: - Fileprivate
    fileprivate func setupMainStackView() {
        let mainStackView = UIStackView(arrangedSubviews: [topNavigationStackView, cardDeckView , bottomStackView])
        mainStackView.axis = .vertical
        
        view.addSubview(mainStackView)
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        mainStackView.bringSubviewToFront(cardDeckView)
    }
    
    fileprivate func setupCardView() {
        users.forEach { (user) in
            let cardView = CardView()
            cardView.imageView.image = UIImage(named: user.imageName)
            cardView.informationLabel.text = "\(user.name) \(user.age)\n \(user.profession)"
            
            let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont(name: "AvenirNext-Bold", size: 24)!])
            attributedText.append(NSAttributedString(string: "  \(user.age)", attributes: [.font: UIFont(name: "AvenirNext-Medium", size: 18)!]))
            attributedText.append(NSAttributedString(string: "  \n\(user.profession)", attributes: [.font: UIFont(name: "AvenirNext-Medium", size: 16)!]))
            cardView.informationLabel.attributedText = attributedText
            
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}


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
    
    let cardViewModels: [CardViewModel] = {
        let producers = [
                    User(name: "Gambit", age: 34, profession: "Card Strickstar", imageName: "gambit"),
                    User(name: "Logan", age: 100, profession: "Army Person", imageName: "logan"),
                    User(name: "Perter", age: 32, profession: "Camera Man", imageName: "peter"),
                    User(name: "Berry", age: 25, profession: "Student", imageName: "flash"),
                    User(name: "Deadpool", age: 45, profession: "Idiocracy", imageName: "deadpool"),
                    User(name: "Bruce Wayne", age: 60, profession: "Billionaire", imageName: "batman"),
                    User(name: "Dr.Strange", age: 42, profession: "Doctor", imageName: "strange"),
                    Advertiser(title: "Black Panther", brandName: "It's so Black", posterPhotoName: "panther")
        ] as [ProducesCarViewModel]
        let viewModels = producers.map({ return $0.toCardViewModel()})
        return viewModels
    }()
    
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
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardViewModel
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}


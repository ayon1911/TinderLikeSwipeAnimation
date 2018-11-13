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
                    User(name: "Gambit", age: 34, profession: "Card Strickstar", imageNames: ["gambit"]),
                    User(name: "Logan", age: 100, profession: "Army Person", imageNames: ["logan"]),
                    User(name: "Perter", age: 32, profession: "Camera Man", imageNames: ["peter"]),
                    Advertiser(title: "Black Panther", brandName: "It's so Black", posterPhotoName: "panther"),
                    User(name: "Deadpool", age: 45, profession: "Idiocracy", imageNames: ["deadpool"]),
                    User(name: "Bruce Wayne", age: 60, profession: "Billionaire", imageNames: ["batman"]),
                    User(name: "Berry", age: 25, profession: "Student", imageNames: ["flash", "flash2", "flash3"]),
                    User(name: "Dr.Strange", age: 42, profession: "Doctor", imageNames: ["strange", "strange2", "strange3"])
                    
        ] as [ProducesCarViewModel]
        let viewModels = producers.map({ return $0.toCardViewModel()})
        return viewModels
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topNavigationStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
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
    //MARK:- handler functions
    @objc fileprivate func handleSettings() {
        let registrationVC = RegistrationVC()
        present(registrationVC, animated: true, completion: nil)
    }
}


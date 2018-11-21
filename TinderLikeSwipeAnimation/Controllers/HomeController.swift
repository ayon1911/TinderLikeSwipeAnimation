//
//  ViewController.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 07.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    //MARK:- variables
    let topNavigationStackView = TopNavigationStackView()
    let bottomControls = HomeBottomControlsStackView()
    let cardDeckView = UIView()
    
    var cardViewModels = [CardViewModel]()
    //this variable keeps track of the last fetched user so that we can paginate through firebases
    var lastFetchedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topNavigationStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setupMainStackView()
        fetchUserFromFireStote()
    }

    //MARK: - Fileprivate
    fileprivate func setupMainStackView() {
        view.backgroundColor = .white
        let mainStackView = UIStackView(arrangedSubviews: [topNavigationStackView, cardDeckView , bottomControls])
        mainStackView.axis = .vertical
        
        view.addSubview(mainStackView)
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        mainStackView.bringSubviewToFront(cardDeckView)
    }
    //MARK:- fileprivate
    fileprivate func fetchUserFromFireStote() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching User"
        hud.show(in: view)
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments { (snapshot, error) in
            hud.dismiss()
            if let err = error {
                print("Failed to fetch user:", err)
                return
            }
            snapshot?.documents.forEach({ (snapshot) in
                let userDict = snapshot.data()
                let user = User(dictionary: userDict)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCarFromUser(user: user)
            })
        }
    }
    
    fileprivate func setupCarFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    //MARK:- handler functions
    @objc fileprivate func handleSettings() {
        let settingsVC = SettingsVC()
        let nav = UINavigationController(rootViewController: settingsVC)
        present(nav, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleRefresh() {
        fetchUserFromFireStote()
    }
}


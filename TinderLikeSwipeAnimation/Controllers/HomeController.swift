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

class HomeController: UIViewController, SettingsVCDelegate, LoginControllerDelegate, CardViewDelegate {
    
    //MARK:- variables
    let topNavigationStackView = TopNavigationStackView()
    let bottomControls = HomeBottomControlsStackView()
    let cardDeckView = UIView()
    
    var cardViewModels = [CardViewModel]()
    //this variable keeps track of the last fetched user so that we can paginate through firebases
    var lastFetchedUser: User?
    fileprivate var user: User?
    fileprivate var hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topNavigationStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setupMainStackView()
        //        fetchUserFromFireStote()
                fetchCurrentUser()
//        try? Auth.auth().signOut()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let registrationVC = RegistrationVC()
            registrationVC.delegate = self
            let nav = UINavigationController(rootViewController: registrationVC)
            present(nav, animated: true, completion: nil)
        }
    }
    
    //MARK: - Fileprivate
    fileprivate func fetchCurrentUser() {
        self.hud.textLabel.text = "Loading"
        self.hud.show(in: self.view)
        FetchUserService.shared.fetchCurrentUser { (user, error) in
            if let err = error {
                print(err)
                self.hud.dismiss(animated: true)
                return
            }
            self.user = user
            self.fetchUserFromFireStote()
        }
    }
    
    
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
        let minAge = user?.minAge ?? DEFAULT_MIN_AGE
        let maxAge = user?.maxAge ?? DEFAULT_MAX_AGE
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        query.getDocuments { (snapshot, error) in
            self.hud.dismiss()
            if let err = error {
                print("Failed to fetch user:", err)
                return
            }
            snapshot?.documents.forEach({ (snapshot) in
                let userDict = snapshot.data()
                let user = User(dictionary: userDict)
                if user.uid != Auth.auth().currentUser?.uid {
                    self.setupCardFromUser(user: user)
                }
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    func didFinishLoginIn() {
        fetchCurrentUser()
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsVC = UserDetailsVC()
        userDetailsVC.cardViewModel = cardViewModel
        present(userDetailsVC, animated: true, completion: nil)
    }
    //MARK:- handler functions
    @objc fileprivate func handleSettings() {
        let settingsVC = SettingsVC()
        settingsVC.delegate = self
        let nav = UINavigationController(rootViewController: settingsVC)
        present(nav, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleRefresh() {
        fetchUserFromFireStote()
    }
    
    func didSaveSettings() {
        fetchCurrentUser()
    }
}


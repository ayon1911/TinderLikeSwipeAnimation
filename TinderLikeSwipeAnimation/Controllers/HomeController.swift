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
    var swipes = [String: Int]()
    //this variable keeps track of the last fetched user so that we can paginate through firebases
    var lastFetchedUser: User?
    var topCardView: CardView?
    fileprivate var user: User?
    fileprivate var hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topNavigationStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
        setupMainStackView()
        fetchCurrentUser()
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
            self.fetchSwipes()
            self.fetchUserFromFireStote()
        }
    }

    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, error) in
            if let err = error {
                print("Failed to fetch swipes for the current user", err)
                return
            }
            guard let data = snapshot?.data() as? [String: Int] else { return }
            self.swipes = data
//            self.fetchUserFromFireStote()
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
        topCardView = nil
        query.getDocuments { (snapshot, error) in
            self.hud.dismiss()
            if let err = error {
                print("Failed to fetch user:", err)
                return
            }
            
            var previousCardView: CardView?
            snapshot?.documents.forEach({ (snapshot) in
                let userDict = snapshot.data()
                let user = User(dictionary: userDict)
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
//                let hasNotSwipeBefore = self.swipes[user.uid!] == nil
                let hasNotSwipeBefore = true
                if isNotCurrentUser && hasNotSwipeBefore {
                    let cardView = self.setupCardFromUser(user: user)
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    func didFinishLoginIn() {
        fetchCurrentUser()
    }
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
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
        cardDeckView.subviews.forEach({$0.removeFromSuperview()})
        fetchUserFromFireStote()
    }
    @objc fileprivate func handleLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(traslation: 700, angle: 15)
    }
    @objc fileprivate func handleDislike() {
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(traslation: -700, angle: -15)
    }
    
    func didSaveSettings() {
        fetchCurrentUser()
    }
    
    func cardDidLike(didLike: Int) {
        if didLike == 1 {
            handleLike()
        } else {
            handleDislike()
        }
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let cardUID = topCardView?.cardViewModel.uid else { return }
        
        
        let documentData = [cardUID: didLike]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, error) in
            if let err = error {
                print("Failed to fetch swipe data:", err)
            }
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (error) in
                    if let err = error {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    if didLike == 1 { self.checkIfMatchExists(cardUID: cardUID) }
                    print("Successfully Updated swipe data ")
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (error) in
                    if let err = error {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    print("Successfully save swipe data ")
                    if didLike == 1 { self.checkIfMatchExists(cardUID: cardUID) }
                }
            }
        }
    }
    
    fileprivate func checkIfMatchExists(cardUID: String) {
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, error) in
            if let err = error {
                print("Failed to fetch document for card user:", err)
                return
            }
            guard let data = snapshot?.data() else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let hasMatched = data[uid] as? Int == 1
            if hasMatched {
            self.presentMatchView(cardUID: cardUID)
            }
        }
    }
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    fileprivate func performSwipeAnimation(traslation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let traslationAnimation = CABasicAnimation(keyPath: "position.x")
        traslationAnimation.toValue = traslation
        traslationAnimation.duration = duration
        traslationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        traslationAnimation.fillMode = .forwards
        traslationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(traslationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
    }
}


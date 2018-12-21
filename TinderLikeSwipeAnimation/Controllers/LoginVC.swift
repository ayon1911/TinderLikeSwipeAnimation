//
//  LoginVC.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 27.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol LoginControllerDelegate {
    func didFinishLoginIn()
}

class LoginVC: UIViewController {

    //MARK:- VARIABLES & PROPERTIES
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let loginViewModel = LoginViewModel()
    fileprivate let loginHUD = JGProgressHUD(style: .dark)
    var delegate: LoginControllerDelegate?
    
    let emailTextField: CustomTextField = {
       let tf = CustomTextField(padding: 20, height: 50)
        tf.placeholder = "Enter Email"
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    let passwordTextField: CustomTextField = {
       let tf = CustomTextField(padding: 20, height: 50)
        tf.placeholder = "Enter Password"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.setTitle("Login", for: .normal)
        button.isEnabled = false
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 24)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
       return button
    }()
    
    lazy var verticalStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [
        emailTextField, passwordTextField, logInButton
        ])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    let backButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Go To Registration", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 22)
        button.addTarget(self, action: #selector(handleGoBackButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientlayer()
        setupLayouts()
        setupBindables()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    //MARK:- SETUP LAYOUTS & FUNCTIONS
    fileprivate func setupLayouts() {
        navigationController?.isNavigationBarHidden = true
        view.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(backButton)
        backButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, trailing: view.trailingAnchor)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        listenNotificationObservers()
    }
    
    fileprivate func setupGradientlayer() {
        let topColor = #colorLiteral(red: 0.4078431373, green: 0.4274509804, blue: 0.8784313725, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.5176470588, green: 0.2156862745, blue: 0.4901960784, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupBindables() {
        loginViewModel.isFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.logInButton.isEnabled = isFormValid
            self.logInButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1) : .lightGray
            self.logInButton.setTitleColor(isFormValid ? .white : .gray, for: .normal)
        }
        loginViewModel.isLoggedIn.bind {[unowned self] (isLoggedIn) in
            if isLoggedIn == true {
                self.loginHUD.textLabel.text = "Loging In.."
                self.loginHUD.show(in: self.view)
            } else {
                self.loginHUD.dismiss()
            }
        }
    }
    
    @objc fileprivate func handleTap() {
        view.endEditing(true)
    }
    
    fileprivate func listenNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        
        let bottomSpace = view.frame.height - verticalStackView.frame.origin.y - verticalStackView.frame.height
        print(bottomSpace)
        
        let delta = keyboardFrame.height - bottomSpace + 8
        self.view.transform = CGAffineTransform(translationX: 0, y: -delta)
    }
    
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        }, completion: nil)
    }
    
    //MARK: - HANDLERS
    @objc fileprivate func handleLogin() {
        loginViewModel.performLogin { (error) in
//            self.loginHUD.dismiss()
            if let err = error {
                print("failed to login", err)
                return
            }
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishLoginIn()
            })
        }
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    @objc fileprivate func handleGoBackButton() {
        navigationController?.popViewController(animated: true)
        print("Go to Registration")
    }
}

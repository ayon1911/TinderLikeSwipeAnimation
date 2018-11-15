//
//  RegistrationVC.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 12.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {
    
    let gradientLayer = CAGradientLayer()
    let registrationViewModel = RegistrationViewModel()
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 32)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.widthAnchor.constraint(equalToConstant: 275).isActive = true
        return button
    }()
    let fullNameTextField: CustomTextField = {
        let textField = CustomTextField(padding: 20)
        textField.placeholder = "Enter full name"
        textField.backgroundColor = .white
        textField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return textField
    }()
    let emailTextField: CustomTextField = {
        let textField = CustomTextField(padding: 20)
        textField.placeholder = "Enter Email"
        textField.keyboardType = .emailAddress
        textField.backgroundColor = .white
        textField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return textField
    }()
    let passwordTextField: CustomTextField = {
        let textField = CustomTextField(padding: 20)
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        return textField
    }()
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .disabled)
        button.setTitle("Register", for: .normal)
        button.isEnabled = false
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 24)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            fullNameTextField, emailTextField, passwordTextField, registerButton
            ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton, verticalStackView
        ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        
        setupNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModelObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }

    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.isFormValidObserver = { [unowned self] (isFormValid) in
            self.registerButton.isEnabled = isFormValid
            if isFormValid {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
                self.registerButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            } else {
                self.registerButton.backgroundColor = .lightGray
                self.registerButton.setTitleColor(.gray, for: .normal)
            }
        }
    }
    
    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.4078431373, green: 0.4274509804, blue: 0.8784313725, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.5176470588, green: 0.2156862745, blue: 0.4901960784, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    
    fileprivate func setupLayout() {
        view.addSubview(overallStackView)
        overallStackView.axis = .vertical
        overallStackView.spacing = 8
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 40, bottom: 0, right: 40))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleTextChanged(textField: UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullname = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }
    
    @objc fileprivate func handleTap() {
        self.view.endEditing(true)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        print(bottomSpace)
        
        let delta = keyboardFrame.height - bottomSpace + 8
        self.view.transform = CGAffineTransform(translationX: 0, y: -delta)
    }
    
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        }, completion: nil)
    }
    
}

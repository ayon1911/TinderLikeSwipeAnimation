//
//  MatchView.swift
//  TinderLikeSwipeAnimation
//
//  Created by krAyon on 21.12.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

class MatchView: UIView {
    
    fileprivate let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    fileprivate let currentImageView: UIImageView = {
       let imageView = UIImageView(image: #imageLiteral(resourceName: "peter"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 140 / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    fileprivate let cardUserView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logan"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 140 / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    fileprivate let itsMatchView: UIImageView = {
       let imageView = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
            You and X have liked
            each other
        """
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-Medium", size: 20)
        label.numberOfLines = 0
        return label
    }()
    fileprivate let sendMessageButton: UIButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    fileprivate let keepSwipeButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("KEEP SWIPE", for: .normal)
        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .yellow
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
        setupLayout()
        setupAnimation()
    }
    
    fileprivate func setupAnimation() {
        let angel = 30 * CGFloat.pi / 180
        currentImageView.transform = CGAffineTransform(rotationAngle: -angel).concatenating(CGAffineTransform(translationX: 200, y: 0))
        cardUserView.transform = CGAffineTransform(rotationAngle: angel).concatenating(CGAffineTransform(translationX: -200, y: 0))
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipeButton.transform = CGAffineTransform(translationX: 500, y: 0)
        //keyframe animetion helps to break down animations into segments of animation
        UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: .calculationModeCubic, animations: {
            //translation animation
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.currentImageView.transform = CGAffineTransform(rotationAngle: -angel)
                self.cardUserView.transform = CGAffineTransform(rotationAngle: angel)
            })
            //rotation animation
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.currentImageView.transform = .identity
                self.cardUserView.transform = .identity
            })
        })
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
            self.sendMessageButton.transform = .identity
            self.keepSwipeButton.transform = .identity
        })
    }
    
    fileprivate func setupLayout() {
        addSubview(itsMatchView)
        addSubview(descriptionLabel)
        addSubview(currentImageView)
        addSubview(cardUserView)
        addSubview(sendMessageButton)
        addSubview(keepSwipeButton)
        
        itsMatchView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
        itsMatchView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        descriptionLabel.anchor(top: nil, leading: leadingAnchor, bottom: currentImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 32, right: 16), size: .init(width: 0, height: 50))
        
        currentImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 140, height: 140))
        currentImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cardUserView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: .init(width: 140, height: 140))
        cardUserView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        sendMessageButton.anchor(top: currentImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 50))
        keepSwipeButton.anchor(top: sendMessageButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 50))
    }
    
    fileprivate func setupBlurView() {
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePan)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
        }) { (_) in
            
        }
    }
    
    @objc fileprivate func handlePan() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

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
        let imageView = UIImageView(image: #imageLiteral(resourceName: "peter"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 140 / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSubview(currentImageView)
        addSubview(cardUserView)
        currentImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 140, height: 140))
        currentImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cardUserView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 12, bottom: 0, right: 0), size: .init(width: 140, height: 140))
        cardUserView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
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

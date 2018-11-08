//
//  CardView.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 07.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

class CardView: UIView {
    //MARK:- variables
    fileprivate let threshlod: CGFloat = 80
    let imageView = UIImageView(image: #imageLiteral(resourceName: "gambit"))
    let informationLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.text = " Test name test name age"
        informationLabel.textColor = .yellow
        informationLabel.font = UIFont(name: "AvenirNext-Medium", size: 24)
        informationLabel.numberOfLines = 0
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(pan)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .changed:
            handlePanChanged(gesture)
        case .ended:
            handlePanEnded(gesture)
        default:
            ()
        }
    }
    
    //MARK:- fileprivate
    fileprivate func handlePanChanged(_ gesture: UIPanGestureRecognizer) {
        let traslation = gesture.translation(in: nil)
        let degrees: CGFloat = traslation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTrasnmormation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTrasnmormation.translatedBy(x: traslation.x, y: traslation.y)
    }
    
    fileprivate func handlePanEnded(_ gesture: UIPanGestureRecognizer) {
        let traslationalDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshlod
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.frame = CGRect(x: 600 * traslationalDirection, y: 0, width: self.frame.width, height: self.frame.height)

            } else {
                self.transform = .identity
            }
        }, completion: { (_) in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        })
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  CardView.swift
//  TinderLikeSwipeAnimation
//
//  Created by Khaled Rahman Ayon on 07.11.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
}

class CardView: UIView {
    //MARK:- variables
    var delegate: CardViewDelegate?
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageUrls.first ?? ""
//            imageView.image = UIImage(named: imageName)
            if let url = URL(string: imageName) {
                imageView.sd_setImage(with: url)
            }
            
            informationLabel.attributedText = cardViewModel.attributedtext
            informationLabel.textAlignment = cardViewModel.textAlligenment
            
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barSelectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    
    fileprivate let threshlod: CGFloat = 80
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "gambit"))
    fileprivate let gradientlayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    fileprivate let barsStackView = UIStackView()
    fileprivate let barSelectedColor = UIColor(white: 0.5, alpha: 0.5)
    fileprivate let moreInfoButton: UIButton = {
       let button = UIButton(type: .system)
        button.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setImage(#imageLiteral(resourceName: "moreInfo").withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfoButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    //MARK:- fileprivate
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
        
        setupGradientLayer()
        setupBarsStackView()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        informationLabel.textColor = .yellow
        informationLabel.numberOfLines = 0
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
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
    
    fileprivate func setupGradientLayer() {
        gradientlayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientlayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientlayer)
    }
    
    fileprivate func setupBarsStackView() {
       addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }
    
    //MARK:- handlers
    @objc fileprivate func handleMoreInfoButton() {
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (view) in
                view.layer.removeAllAnimations()
            })
        case .changed:
            handlePanChanged(gesture)
        case .ended:
            handlePanEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [unowned self] (index, imageUrl) in
            if let url = URL(string: imageUrl ?? "") {
                self.imageView.sd_setImage(with: url)
            }
            
            self.barsStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = self.barSelectedColor
            })
            self.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvanceNextPhoto{
            cardViewModel.advanceToNextImage()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    override func layoutSubviews() {
        gradientlayer.frame = self.frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

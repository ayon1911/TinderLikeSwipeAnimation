//
//  SwipingPhotosVC.swift
//  TinderLikeSwipeAnimation
//
//  Created by krAyon on 11.12.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit
import AVFoundation

class SwipingPhotosVC: UIPageViewController {
    //MARK:- Variables & Properties
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
            setupBarViews()
        }
    }
    var controllers = [UIViewController]()
    fileprivate let isCardViewMode: Bool
    
    fileprivate let barStackView = UIStackView(arrangedSubviews: [])
    fileprivate let deSelectedBarColor = UIColor(white: 0, alpha: 0.1)
    
    
    init(isCardViewMode: Bool = false) {
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        if isCardViewMode {
            disableSwipingAbility()
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        guard let currentController = viewControllers?.first else { return }
        guard let index = controllers.firstIndex(of: currentController) else { return }
        barStackView.arrangedSubviews.forEach({$0.backgroundColor = deSelectedBarColor})
        if gesture.location(in: self.view).x > view.frame.width / 2 {
            let nextIndex = min(index + 1, controllers.count - 1)
            let nextController = controllers[nextIndex]
            self.setViewControllers([nextController], direction: .forward, animated: true)
            barStackView.arrangedSubviews[nextIndex].backgroundColor = .white
        } else {
            let prevIndex = max(0, index - 1)
            let prevController = controllers[prevIndex]
            self.setViewControllers([prevController], direction: .reverse, animated: true)
            barStackView.arrangedSubviews[prevIndex].backgroundColor = .white
        }
        
    }
    
    fileprivate func disableSwipingAbility() {
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    
    fileprivate func setupBarViews() {
        cardViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = deSelectedBarColor
            barView.layer.cornerRadius = 2
            barStackView.addArrangedSubview(barView)
        }
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        barStackView.spacing = 8
        barStackView.distribution = .fillEqually
        view.addSubview(barStackView)
        
        var paddingTop: CGFloat = 8
        if !isCardViewMode {
            paddingTop += UIApplication.shared.statusBarFrame.height
        }
        barStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
}

extension SwipingPhotosVC: UIPageViewControllerDataSource  {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
}

extension SwipingPhotosVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentController }) {
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = deSelectedBarColor})
            barStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
}


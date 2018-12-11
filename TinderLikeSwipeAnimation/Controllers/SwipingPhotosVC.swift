//
//  SwipingPhotosVC.swift
//  TinderLikeSwipeAnimation
//
//  Created by krAyon on 11.12.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit

class SwipingPhotosVC: UIPageViewController {
    
    let controllers = [
        PhotoController(image: #imageLiteral(resourceName: "flash2")),
        PhotoController(image: #imageLiteral(resourceName: "strange2")),
        PhotoController(image: #imageLiteral(resourceName: "deadpool")),
        PhotoController(image: #imageLiteral(resourceName: "batman"))
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
    }

}

extension SwipingPhotosVC: UIPageViewControllerDataSource  {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
    }
}

class PhotoController: UIViewController {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "peter"))
    
    init(image: UIImage) {
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

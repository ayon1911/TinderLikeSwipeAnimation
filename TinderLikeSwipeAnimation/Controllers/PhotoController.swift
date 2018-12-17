//
//  PhotoController.swift
//  TinderLikeSwipeAnimation
//
//  Created by krAyon on 13.12.18.
//  Copyright © 2018 DocDevs. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoController: UIViewController {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "peter"))
    
    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url, completed: nil)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

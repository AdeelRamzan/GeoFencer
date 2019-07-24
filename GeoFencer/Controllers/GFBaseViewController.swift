//
//  GFBaseViewController.swift
//  GeoFencer
//
//  Created by Muhammad Adeel Ramzan on 22/07/2019.
//  Copyright © 2019 Muhammad Adeel Ramzan. All rights reserved.
//

import UIKit

class GFBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleLabel.textColor = kThemeTintColor
        navigationItem.detailLabel.textColor = kThemeTintColor
    }
}

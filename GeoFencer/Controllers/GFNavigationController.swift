//
//  GFNavigationController.swift
//  GeoFencer
//
//  Created by Muhammad Adeel Ramzan on 22/07/2019.
//  Copyright © 2019 Muhammad Adeel Ramzan. All rights reserved.
//

import UIKit
import Material

class GFNavigationController: NavigationController {
    
    open override func prepare() {
        super.prepare()
        
        guard let navigationBar = navigationBar as? NavigationBar else {
            return
        }
        
        navigationBar.backButtonImage = Icon.cm.arrowBack?.tint(with: Color.white)
        navigationBar.barTintColor = kThemeBackgroundColor
        navigationBar.tintColor = kThemeTintColor
        navigationBar.isTranslucent = false
    }
}

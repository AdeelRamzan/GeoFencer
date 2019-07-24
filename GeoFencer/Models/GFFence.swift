//
//  GFFence.swift
//  GeoFencer
//
//  Created by Muhammad Adeel Ramzan on 22/07/2019.
//  Copyright © 2019 Muhammad Adeel Ramzan. All rights reserved.
//

import CoreLocation

class GFFence {
    
    var wifiName: String!
    var radiusInMeters: Float!
    var locationCoordinate: CLLocationCoordinate2D!
    var location: CLLocation!
    
    init(wifiName: String, radius: Float, locationCoordinate: CLLocationCoordinate2D) {
        self.wifiName = wifiName
        self.radiusInMeters = radius * 1000.0
        self.locationCoordinate = locationCoordinate
        self.location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
    }
}

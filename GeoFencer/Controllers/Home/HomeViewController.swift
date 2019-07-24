//
//  HomeViewController.swift
//  GeoFencer
//
//  Created by Muhammad Adeel Ramzan on 22/07/2019.
//  Copyright © 2019 Muhammad Adeel Ramzan. All rights reserved.
//

import UIKit
import Material
import CoreLocation
import MapKit
import Foundation
import Reachability

class HomeViewController: GFBaseViewController {
    
    @IBOutlet weak var addFenceButton: FABButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var statusLabel: UILabel!
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var reachability = Reachability()
    private var currentFence: GFFence?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleLabel.text = "Geo Fencer"
        navigationItem.detailLabel.text = "Add location to start fencing"
        
        addFenceButton.setImage(Icon.add, for: .normal)
        
        NotificationCenter.default.addObserver( self, selector: #selector(self.reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        
        if let reachability = reachability {
            do{
                try reachability.startNotifier()
            } catch {
                print("could not start reachability notifier")
            }
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "entry" {
            if let entryViewController = segue.destination as? EntryViewController {
                entryViewController.delegate = self
            }
        }
    }
    
    @objc private func reachabilityChanged(notification: Notification) {
        updateFenceStatus()
    }
    
    private func updateFenceStatus() {
        guard let fence = currentFence else {
            return
        }
        
        var isInsideCurrentLocation = false
        
        if let location = currentLocation, Float(location.distance(from: fence.location)) <= fence.radiusInMeters {
            isInsideCurrentLocation = true
        }
        
        var isConnectedToCorrectwifi = false
        
        if reachability?.connection == .wifi {
            if kUtility.currentWifiName() == fence.wifiName {
                isConnectedToCorrectwifi = true
            }
        }
        
        if isInsideCurrentLocation || isConnectedToCorrectwifi {
            statusLabel.text = "Status: Inside"
        } else {
            statusLabel.text = "Status: Outside"
        }
        
        statusLabel.isHidden = false
    }
}

extension HomeViewController: GeoFenceEntryDelegate {
    
    func didAddFence(fence: GFFence) {
        currentFence = fence
        
        mapView.setCenter(fence.locationCoordinate, animated: true)
        
        mapView.region = MKCoordinateRegion(
            center: fence.locationCoordinate,
            latitudinalMeters: CLLocationDistance(fence.radiusInMeters * 2),
            longitudinalMeters: CLLocationDistance(fence.radiusInMeters * 2)
        )
        
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addOverlay(MKCircle(center: fence.locationCoordinate, radius: CLLocationDistance(fence.radiusInMeters)))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = fence.locationCoordinate
        mapView.addAnnotation(annotation)
        
        updateFenceStatus()
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleOverlay = MKCircleRenderer(overlay: overlay)
        circleOverlay.strokeColor = UIColor.red
        circleOverlay.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
        circleOverlay.lineWidth = 1
        return circleOverlay
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if let pinImage = UIImage(named: "pin") {
            annotationView.centerOffset = .init(x: 0, y: -pinImage.size.height / 2.0)
            annotationView.canShowCallout = false
            annotationView.image = pinImage
        }
        
        return annotationView
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location
        
        updateFenceStatus()
    }
}

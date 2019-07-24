//
//  EntryViewController.swift
//  GeoFencer
//
//  Created by Muhammad Adeel Ramzan on 22/07/2019.
//  Copyright © 2019 Muhammad Adeel Ramzan. All rights reserved.
//

import UIKit
import MapKit
import Material

protocol GeoFenceEntryDelegate {
    func didAddFence(fence: GFFence)
}

class EntryViewController: GFBaseViewController {
    
    @IBOutlet weak var wifiNameTextField: TextField!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var mapView: MKMapView!
    
    private let checkButton = IconButton(image: Icon.check, tintColor: kThemeTintColor)
    
    var delegate: GeoFenceEntryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkButton.isEnabled = false
        checkButton.addTarget(self, action: #selector(addFence), for: .touchUpInside)
        checkButton.setImage(Icon.check?.tint(with: .lightGray), for: .disabled)
        navigationItem.rightViews = [checkButton]
        
        navigationItem.titleLabel.text = "Add Fence"
        navigationItem.detailLabel.text = "Enter wifi name, adjust radius & center to fence"
        
        radiusSlider.minimumValue = kRadiusMinimumRangeInKm
        radiusSlider.maximumValue = kRadiusMaximumRangeInKm
        radiusSlider.value = (kRadiusMinimumRangeInKm + kRadiusMaximumRangeInKm) / 2.0
        
        radiusLabel.text = "\(Int(radiusSlider.value)) km"
    }
    
    @IBAction func radiusChanged(_ sender: UISlider) {
        radiusLabel.text = "\(Int(sender.value)) km"
    }
    
    @objc private func addFence() {
        delegate?.didAddFence(fence: GFFence(wifiName: wifiNameTextField.text!, radius: radiusSlider.value, locationCoordinate: mapView.centerCoordinate))
        
        navigationController?.popViewController(animated: true)
    }
}

extension EntryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.count > 0 {
            checkButton.isEnabled = true
        } else {
            checkButton.isEnabled = false
        }
    }
}

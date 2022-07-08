//
//  LocationManager.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 05/07/2022.
//

import UIKit
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func locationManagerDidChangeAuthorization(_ status: CLAuthorizationStatus)
}

final class LocationManager: NSObject {
    
    weak var delegate: LocationManagerDelegate?
    
    private var manager: CLLocationManager!
    
    var currentLocationCoordinate: CLLocationCoordinate2D? {
        manager.location?.coordinate
    }
    
    static var shared: LocationManager = {
        .init()
    }()
    
    
    func requestLocationAuthorization() {
        manager                 = .init()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate        = self
        
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        delegate?.locationManagerDidChangeAuthorization(manager.authorizationStatus)
    }
}

//
//  LocationManager.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 05/07/2022.
//

import UIKit
import CoreLocation
import MapKit

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
    
    func search(term: String, inRegion region: MKCoordinateRegion) async -> [MKMapItem]? {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = term
        searchRequest.region = region
        
        let search = MKLocalSearch(request: searchRequest)

        do {
            let response = try await search.start()
            return response.mapItems
            
        } catch {
            print("\n~~> [LocationManager] Failed to fetch results for term: \(term) with error: \(error.localizedDescription)")
            return nil
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        delegate?.locationManagerDidChangeAuthorization(manager.authorizationStatus)
    }
}

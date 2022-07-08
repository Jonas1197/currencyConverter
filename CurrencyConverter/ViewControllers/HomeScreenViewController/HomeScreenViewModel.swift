//
//  HomeScreenViewModel.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 01/07/2022.
//

import UIKit
import CoreLocation
import FloatingPanel
import Combine
import MapKit

protocol HomeScreenOutput: AnyObject {
    
}

final class HomeScreenViewModel: NSObject {
    weak var output: HomeScreenOutput?
    
    @Published var isKeyboardShowing: Bool?
    
    init(output: HomeScreenOutput?) {
        super.init()
        self.output = output
    }
    
    func zoomOnUserLocation(with mapView: MKMapView) {
        guard let coordinate = LocationManager.shared.currentLocationCoordinate else {
            print("\n~~> Could not get current location coordinate.")
            return
        }
        
        DispatchQueue.main.async {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
            mapView.showsUserLocation = true
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func listenToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func keyboardWillDisappear() {
        isKeyboardShowing = false
    }
    
    @objc private func keyboardWillAppear() {
        isKeyboardShowing = true
    }
}

//MARK: - FloatingPanelControllerDelegate
extension HomeScreenViewModel: FloatingPanelControllerDelegate {
    
}

//MARK: - LocationManagerDelegate
extension HomeScreenViewModel: LocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            print("\n~~> Location authorization denied.")
            
        case .authorized:
            print("\n~~> Location authorized!")
            
        case .authorizedAlways:
            print("\n~~> Location authorized!")
            
        case .authorizedWhenInUse:
            print("\n~~> Location authorized!")
            
        default:
            print("Defualt.")
        }
    }
}

//MARK: - MKMapView
extension HomeScreenViewModel: MKMapViewDelegate {
 
}

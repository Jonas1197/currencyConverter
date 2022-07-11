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
import NotSwiftUI

protocol HomeScreenOutput: AnyObject {
    
}

final class HomeScreenViewModel: NSObject {
    weak var output: HomeScreenOutput?
    weak var floatingPanel: FloatingPanelController?
    
    @Published var isKeyboardShowing:     Bool?
    @Published var currentUserRegion:     MKCoordinateRegion?
    @Published var searchResults:         [MKMapItem] = []
    @Published var selectedMapItem:       MKMapItem?
    
    init(output: HomeScreenOutput?) {
        super.init()
        self.output = output
    }
    
    func zoomOnUserLocation() {
        guard let coordinate = LocationManager.shared.currentLocationCoordinate else {
            print("\n~~> Could not get current location coordinate.")
            return
        }
        
        currentUserRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
    }
    
    func listenToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func presentConverterPanel() {
        guard let floatingPanel = floatingPanel else { return }
        floatingPanel.move(to: .hidden, animated: true)
        let viewModel      = ConverterPanelViewModel(floatingPanel: floatingPanel)
        viewModel.delegate = self
        let vc             = ConverterPanelViewController(viewModel: viewModel)
        floatingPanel.set(contentViewController: vc)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            floatingPanel.move(to: .half, animated: true)
        }
    }
    
    func presentSiteInfoPanel(forSelectedItem item: MKMapItem) {
        guard let floatingPanel = floatingPanel else { return }
        floatingPanel.move(to: .hidden, animated: true)
        let vc = SiteInfoViewController(viewModel: .init(floatingPanel: floatingPanel, item: item))
        vc.viewModel.delegate = self
        floatingPanel.set(contentViewController: vc)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            floatingPanel.move(to: .half, animated: true)
        }
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
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        
        if let converterPanel = floatingPanel?.contentViewController as? ConverterPanelViewController {
            converterPanel.viewModel.floatingPanelState = fpc.state
            
        } else if let sitePanel = floatingPanel?.contentViewController as? SiteInfoViewController {
            sitePanel.viewModel.floatingPanelState = fpc.state
        }
    }
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

//MARK: - ConverterPanelDelegate
extension HomeScreenViewModel: ConverterPanelDelegate {
    func findConversionStores() {
        searchResults = []
        
        zoomOnUserLocation()
        Task {
            guard let results = await LocationManager.shared.search(term: "Money Exchange", inRegion: currentUserRegion) else { return }
            self.searchResults = results
        }
    }
}

//MARK: - SiteInfoDelegate
extension HomeScreenViewModel: SiteInfoDelegate {
    func userTappedBackButton() {
        presentConverterPanel()
    }
}

//MARK: - MKMapView
extension HomeScreenViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        if let selectedResult = searchResults.first(where: { $0.placemark.coordinate.latitude == annotation.coordinate.latitude && $0.placemark.coordinate.longitude == annotation.coordinate.longitude }) {
            selectedMapItem = selectedResult
        }
    }
}

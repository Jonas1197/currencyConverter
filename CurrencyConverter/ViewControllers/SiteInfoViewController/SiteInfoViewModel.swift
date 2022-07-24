//
//  SiteInfoViewModel.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 10/07/2022.
//

import UIKit
import MapKit
import FloatingPanel

protocol SiteInfoDelegate: AnyObject {
    func userTappedBackButton()
}

final class SiteInfoViewModel: NSObject {
    weak var delegate:      SiteInfoDelegate?
    weak var floatingPanel: FloatingPanelController?
    weak var item:          MKMapItem?
    
    @Published var navigationAlert:    UIAlertController?
    @Published var floatingPanelState: FloatingPanelState?
    
    //MARK: - Lifecycle
    init(floatingPanel: FloatingPanelController, item: MKMapItem) {
        super.init()
        self.floatingPanel = floatingPanel
        self.item          = item
    }
    
    func handleBackButtonTapped() {
        delegate?.userTappedBackButton()
    }
    
    func open(urlStr: String?) {
        if let str = urlStr,
           let url = URL(string: str) {
            UIApplication.shared.open(url)
        }
    }
    
    func openMapButtonAction() {
        guard let item = item else { return }
        
        let latitude  = Double(item.placemark.coordinate.latitude)
        let longitude = Double(item.placemark.coordinate.longitude)
        
        var installedNavigationApps = [(
            Constants.Navigation.appleMaps().name,
            Constants.Navigation.appleMaps(latitude, longitude).url
        )]
        
        let googleItem = (
            Constants.Navigation.googleMaps().name,
            Constants.Navigation.googleMaps(latitude, longitude).url
        )
        
        let wazeItem = (
            Constants.Navigation.waze().name,
            Constants.Navigation.waze(latitude, longitude).url
        )
        
        if UIApplication.shared.canOpenURL(googleItem.1) {
            installedNavigationApps.append(googleItem)
        }
        
        if UIApplication.shared.canOpenURL(wazeItem.1) {
            installedNavigationApps.append(wazeItem)
        }
        
        let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
        
        for app in installedNavigationApps {
            
            let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            
            alert.addAction(button)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        navigationAlert = alert
    }
}

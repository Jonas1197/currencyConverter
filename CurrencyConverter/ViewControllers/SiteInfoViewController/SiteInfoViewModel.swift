//
//  SiteInfoViewModel.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 10/07/2022.
//

import UIKit
import MapKit
import FloatingPanel

final class SiteInfoViewModel: NSObject {
    
    weak var floatingPanel: FloatingPanelController?
    weak var item:          MKMapItem?
    
    @Published var navigationAlert: UIAlertController?
    
    //MARK: - Lifecycle
    init(floatingPanel: FloatingPanelController, item: MKMapItem) {
        super.init()
        self.floatingPanel = floatingPanel
        self.item          = item
    }
    
    func open(urlStr: String?) {
        if let str = urlStr,
           let url = URL(string: str) {
            UIApplication.shared.open(url)
        }
    }
    
    func openMapButtonAction() {
        guard let item = item else { return }
        
        let latitude   = Double( item.placemark.coordinate.latitude)
        let longitude  = Double( item.placemark.coordinate.longitude)
 
        let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
        let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"
        
        let googleItem = ("Google Map", URL(string:googleURL)!)
        let wazeItem = ("Waze", URL(string:wazeURL)!)
        var installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]
        
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

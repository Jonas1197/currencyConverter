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
    
    //MARK: - Lifecycle
    init(floatingPanel: FloatingPanelController, item: MKMapItem) {
        super.init()
        self.floatingPanel = floatingPanel
        self.item          = item
    }
}

//
//  HomeScreenViewController.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 01/07/2022.
//

import UIKit
import MapKit
import FloatingPanel
import NotSwiftUI

final class HomeScreenViewController: BaseViewController<HomeScreenViewModel> {

    @IBOutlet weak var mapView:        MKMapView!
    @IBOutlet weak var locateMeButton: UIButton!
    @IBOutlet weak var pageControlSegment: UISegmentedControl!
    
    private var floatingPanel: FloatingPanelController!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        locateMeButton.roundCorners(to: .rounded)
    }
    
    
    //MARK: - SetUp
    private func setUp() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        LocationManager.shared.delegate = viewModel
        LocationManager.shared.requestLocationAuthorization()
        
        configureFloatingPanel()
        configureLocateMeButton()
        configurePageControlSegment()
        
        mapView.delegate = viewModel
    }
    
    private func configureFloatingPanel() {
        floatingPanel = .init(delegate: viewModel)
        floatingPanel.set(contentViewController: ConverterPanelViewController(viewModel: .init(floatingPanel: floatingPanel)))
        floatingPanel.isRemovalInteractionEnabled = false
        
        let appearence = SurfaceAppearance()
        let shadow = SurfaceAppearance.Shadow()
        shadow.offset  = .init(width: 0, height: -6)
        shadow.radius  = 12
        shadow.color   = .black
        shadow.opacity = 0.2
        
        appearence.shadows         = [shadow]
        appearence.cornerCurve     = .continuous
        appearence.cornerRadius    = 20
        appearence.backgroundColor = Constants.Colors.background
        
        floatingPanel.surfaceView.appearance = appearence
        
        present(floatingPanel, animated: true, completion: nil)
    }
    
    private func configureLocateMeButton() {
        locateMeButton.shadowed(with: .black, offset: .init(width: 0, height: -3), radius: 12, 0.3)
    }
    
    private func configurePageControlSegment() {
        pageControlSegment.setTitleTextAttributes([.foregroundColor : Constants.Colors.deepBlue as Any,
                                                    .font : UIFont(name: Constants.Font.bold, size: 14) as Any], for: .selected)
        pageControlSegment.setTitleTextAttributes([.foregroundColor : Constants.Colors.text as Any], for: .normal)
    }
    
    override func subscribeToViewModel(_ viewModel: HomeScreenViewModel) {
        
    }
    
    //MARK: - Actions
    @IBAction func locateMeButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            viewModel.zoomOnUserLocation(with: mapView)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

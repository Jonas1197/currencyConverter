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
import EKSwiftSuite

final class HomeScreenViewController: BaseViewController<HomeScreenViewModel> {

    @IBOutlet weak var mapView:        MKMapView!
    @IBOutlet weak var locateMeButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var buttonsVstack:  UIStackView!
    
    @IBOutlet var buttonsHstackBottomConstraint: NSLayoutConstraint!
    @IBOutlet var buttonsHstackTopConstraint: NSLayoutConstraint!
    
    
    private var floatingPanel: FloatingPanelController!
    
    private var converterPanelViewContrller: ConverterPanelViewController?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        UIDevice.forceOrientation(.portrait)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = [locateMeButton, settingsButton].map { $0!.roundCorners(to: .rounded)}
    }
    
    
    //MARK: - SetUp
    private func setUp() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        mapView.delegate = viewModel
        LocationManager.shared.delegate = viewModel
        LocationManager.shared.requestLocationAuthorization()
        configureFloatingPanel()
        configureButtons()
        
        buttonsHstackTopConstraint.isActive    = true
        buttonsHstackBottomConstraint.isActive = false
        
        mapView.delegate = viewModel
    }
    
    func configureFloatingPanel() {
        floatingPanel = .init(delegate: viewModel)
        self.viewModel.floatingPanel = floatingPanel
        
        let viewModel                    = ConverterPanelViewModel(floatingPanel: floatingPanel)
        viewModel.delegate               = self.viewModel
        self.converterPanelViewContrller = ConverterPanelViewController(viewModel: viewModel)
    
        floatingPanel.set(contentViewController: converterPanelViewContrller!)
        floatingPanel.isRemovalInteractionEnabled = false
        
        let appearence = SurfaceAppearance()
        let shadow     = SurfaceAppearance.Shadow()
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
    
    private func configureButtons() {
        _ = [locateMeButton, settingsButton].map { $0!.shadowed(with: .black, offset: .init(width: 0, height: -3), radius: 12, 0.3)
        }
    }
    
    override func subscribeToViewModel(_ viewModel: HomeScreenViewModel) {
        
        //MARK: Current location region
        subscribe(to: \.$currentUserRegion) { [unowned self] region in
            guard let region = region else { return }
            DispatchQueue.main.async {
                self.mapView.showsUserLocation = true
                self.mapView.setRegion(region, animated: true)
            }
        }
        
        //MARK: - Search results
        subscribe(to: \.$searchResults) { [unowned self] results in
            
            if !results.isEmpty {
                
                let annotations: [MKAnnotation] = results.compactMap {
                    let coordinate        = $0.placemark.coordinate
                    let annotation        = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    return annotation
                }
                
                self.mapView.addAnnotations(annotations)
            }
        }
        
        //MARK: Selected map item
        subscribe(to: \.$selectedMapItem) { item in
            guard let item = item else { return }
            viewModel.presentSiteInfoPanel(forSelectedItem: item)
        }
        
        //MARK: Deselect annotation
        subscribe(to: \.$deselectAnnotation) { [unowned self] deselect in
            guard let _                  = deselect,
                  let selectedAnnotation = mapView.selectedAnnotations.first else { return }
            mapView.deselectAnnotation(selectedAnnotation, animated: true)
        }
        
        subscribe(to: \.$hstackTopConstraintEnabled) { [unowned self] enabled in
            guard let enabled          = enabled,
                  let topConstraint    = buttonsHstackTopConstraint,
                  let bottomConstraint = buttonsHstackBottomConstraint else { return }
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.77, initialSpringVelocity: 1, options: [.allowUserInteraction, .curveEaseInOut]) {
                    topConstraint.isActive    = enabled
                    bottomConstraint.isActive = !enabled
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func locateMeButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            floatingPanel.move(to: .tip, animated: true)
            viewModel.zoomOnUserLocation()
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            floatingPanel.dismiss(animated: true, completion: nil)
            viewModel.presentSettings()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

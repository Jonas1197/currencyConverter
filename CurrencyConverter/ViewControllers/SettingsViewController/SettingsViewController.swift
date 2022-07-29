//
//  SettingsViewController.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 24/07/2022.
//

import UIKit

final class SettingsViewController: BaseViewController<SettingsViewModel> {
    
    @IBOutlet weak var radiusValueLabel: UILabel!
    @IBOutlet weak var radiusSlider:     UISlider!
    @IBOutlet weak var donateButton: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        UIDevice.forceOrientation(.portrait)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        donateButton.rounded(donateButton.frame.height / 4)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.output?.settingsDidDisappear()
    }

    //MARK: - SetUp
    private func setUp() {
        radiusValueLabel.text = "\(UserManager.shared.zoomRadius) meters"
        donateButton.shadowed(with: .black, offset: .init(width: 0, height: 2), radius: 12, 0.3)
    }
    
    //MARK: - Actions
    @IBAction func radiusValueChanged(_ sender: UISlider) {
        let value                     = Int(sender.value)
        radiusValueLabel.text         = "\(value) meters"
        UserManager.shared.zoomRadius = value
        
        // If you want to update the map view live.
//        viewModel.output?.settingsUpdated()
    }
    
    @IBAction func donateButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation {
            //
        }
    }
    
}

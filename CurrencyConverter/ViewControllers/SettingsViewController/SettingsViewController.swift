//
//  SettingsViewController.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 24/07/2022.
//

import UIKit

class SettingsViewController: BaseViewController<SettingsViewModel> {

    
    @IBOutlet weak var radiusValueLabel: UILabel!
    @IBOutlet weak var radiusSlider:     UISlider!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        UIDevice.forceOrientation(.portrait)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.output?.settingsDidDisappear()
    }


    //MARK: - SetUp
    private func setUp() {
        radiusValueLabel.text = "\(UserManager.shared.zoomRadius) meters"
    }
    
    //MARK: - Actions
    @IBAction func radiusValueChanged(_ sender: UISlider) {
        print("\n~~> Zoom radius value: \(sender.value)")
        
        let value = Int(sender.value)
        radiusValueLabel.text = "\(value) meters"
        
        UserManager.shared.zoomRadius = value
        
//        viewModel.output?.settingsUpdated()
    }
    
}

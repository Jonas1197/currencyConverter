//
//  SettingsViewController.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 24/07/2022.
//

import UIKit

class SettingsViewController: BaseViewController<SettingsViewModel> {

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
        
    }

}

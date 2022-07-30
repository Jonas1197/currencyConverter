//
//  SettingsViewController.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 24/07/2022.
//

import UIKit
import NotSwiftUI
import StoreKit

final class SettingsViewController: BaseViewController<SettingsViewModel> {
    
    @IBOutlet weak var titleLabel:                   UILabel!
    @IBOutlet weak var searchRadiusTitleLabel:       UILabel!
    @IBOutlet weak var searchRadiusDescriptionLabel: UILabel!
    @IBOutlet weak var radiusValueLabel:             UILabel!
    @IBOutlet weak var radiusSlider:                 UISlider!
    @IBOutlet weak var donateButton:                 UIButton!
    @IBOutlet weak var donationLabel:                UILabel!
    @IBOutlet weak var donationDescriptionLabel:     UILabel!
    
    
    private var loadingBackground = Object
        .view(backgroundColor: .white.withAlphaComponent(0.7))
        .create()
        .invisible()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = Constants.Colors.deepBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    
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
    
    
    override func subscribeToViewModel(_ viewModel: SettingsViewModel) {
        subscribe(to: \.$purchaseComplete) { [weak self] complete in
            guard let self     = self,
                  let complete = complete else { return }
            
            self.presentTransactionalert(complete)
            self.dismissLoadingView()
        }
    }

    //MARK: - SetUp
    private func setUp() {
        radiusValueLabel.text = "\(UserManager.shared.zoomRadius) meters"
        donateButton.shadowed(with: .black, offset: .init(width: 0, height: 2), radius: 12, 0.3)
        
        if !InAppPurchaseHelper.canMakePurchases {
            donateButton
                .translucent(0.4)
                .isUserInteractionEnabled = false
        } else {
            donateButton
                .translucent(1)
                .isUserInteractionEnabled = true
        }
    }
    
    private func presentLoadingView() {
        DispatchQueue.main.async {
            self.loadingBackground.filled(in: self.view)
            self.loadingIndicator.centered(in: self.loadingBackground)
            
            UIView.animate(withDuration: Constants.General.animationDuration, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) { [weak self] in
                self?.loadingBackground.visible()
                self?.loadingIndicator.startAnimating()
            }
        }
    }
    
    private func dismissLoadingView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constants.General.animationDuration, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) { [weak self] in
                self?.loadingBackground.invisible()
            } completion: { [weak self] _ in
                self?.loadingIndicator.stopAnimating()
                self?.loadingBackground.removeFromSuperview()
                self?.loadingIndicator.removeFromSuperview()
            }

        }
    }
    
    private func presentTransactionalert(_ complete: Bool) {
        let title = complete ? "Purchase complete!" : "Oops!"
        let text = complete ? "Thank you! :)" : "Something went wrong. You were not charged."
        let ac = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Close", style: .cancel)
        ac.addAction(dismiss)
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
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
        sender.actionWithSpringAnimation { [unowned self] in
            presentLoadingView()
            viewModel.makeDonation()
        }
    }
}

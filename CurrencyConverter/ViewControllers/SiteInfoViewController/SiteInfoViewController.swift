//
//  SiteInfoViewController.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 10/07/2022.
//

import UIKit

final class SiteInfoViewController: BaseViewController<SiteInfoViewModel> {
    
    @IBOutlet weak var nameLabel:        UILabel!
    @IBOutlet weak var addressLabel:     UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var urlLabel:         UILabel!
    @IBOutlet weak var goButton:         UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        goButton.rounded(goButton.frame.height / 4)
        
    }

    //MARK: - SetUp
    private func setUp() {
        guard let item = viewModel.item else { return }
        goButton.shadowed(with: .black, offset: .init(width: 0, height: 2), radius: 12, 0.3)
        
        nameLabel.text        = item.name ?? "N/A"
        phoneNumberLabel.text = item.phoneNumber ?? "Not provided by business"
        addressLabel.text     = item.placemark.title ?? "Not provided by business"
        
        if let url = item.url {
            urlLabel
                .setText(url.absoluteString)
                .visible()
                .targeted(self, action: #selector(urlLabelTapped(_:)))
    
        } else {
            urlLabel.invisible()
        }
        
    }
    
    override func subscribeToViewModel(_ viewModel: SiteInfoViewModel) {
        
        //MARK: Present navigation alert
        subscribe(to: \.$navigationAlert) { [unowned self] navigationAlert in
            guard let navigationAlert = navigationAlert else { return }
            present(navigationAlert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Actions
    @IBAction func goButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            viewModel.openMapButtonAction()
        }
    }
    
    @objc private func urlLabelTapped(_ sender: UITapGestureRecognizer) {
        self.urlLabel.actionWithSpringAnimation {
            DispatchQueue.main.async {
                self.viewModel.open(urlStr: self.urlLabel.text)
            }
        }
    }
}

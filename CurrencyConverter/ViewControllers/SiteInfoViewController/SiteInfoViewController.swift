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
        goButton.shadowed(with: .black, offset: .init(width: 0, height: 2), radius: 12, 0.3)
        
        nameLabel.text        = viewModel.item?.name ?? "N/A"
        phoneNumberLabel.text = viewModel.item?.phoneNumber ?? "N/A"
        addressLabel.text     = viewModel.item?.placemark.title ?? "N/A"
        urlLabel.text         = viewModel.item?.url?.absoluteString ?? "N/A"
    }
    
    
    @IBAction func goButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation {
            //
        }
    }
}

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
    @IBOutlet weak var backButton:       UIButton!
    
    private let currencyExchangeView = CurrencyExchangeView.instantiateFromNib()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        UIDevice.forceOrientation(.portrait)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = [goButton, backButton].map { $0?.rounded($0!.frame.height / 4)}
    }

    //MARK: - SetUp
    private func setUp() {
        guard let item = viewModel.item else { return }
        _ = [goButton, backButton].map {
            $0?.shadowed(with: .black, offset: .init(width: 0, height: 2), radius: 12, 0.3)
        }
        
        backButton.bordered(width: 2, color: Constants.Colors.deepBlue!)
        
        nameLabel.text        = item.name            ?? "Not provided by business"
        phoneNumberLabel.text = item.phoneNumber     ?? "Not provided by business"
        addressLabel.text     = item.placemark.title ?? "Not provided by business"
        
        if let url = item.url {
            urlLabel
                .setText(url.absoluteString)
                .visible()
                .targeted(self, action: #selector(urlLabelTapped(_:)))
    
        } else {
            urlLabel.invisible()
        }
        
        configureCurrencyExchangeView()
        localize()
    }
    
    private func localize() {
        let sfSymbolAttachment = NSTextAttachment()
        sfSymbolAttachment.image = .init(systemName: "")
        let goButtonString = NSMutableAttributedString(string: "")
        goButtonString.append(.init(attachment: sfSymbolAttachment))
        goButtonString.append(.init(string: " \(Constants.LocalizedText.siteInfoVC_goButton.localized())"))
        goButton.titleLabel?.attributedText = goButtonString
        backButton.setText(Constants.LocalizedText.siteInfoVC_backButton.localized())
    }
    
    private func configureCurrencyExchangeView() {
        currencyExchangeView.translatesAutoresizingMaskIntoConstraints = false
        currencyExchangeView.configure(withModel: .init(valuesToConvert: UserManager.shared.currencyExchangeViewCurrencies))
        currencyExchangeView.invisible()
        view.addSubview(currencyExchangeView)
        NSLayoutConstraint.activate([
            currencyExchangeView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 42),
            currencyExchangeView.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            currencyExchangeView.trailingAnchor.constraint(equalTo: backButton.trailingAnchor),
            currencyExchangeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -22)
        ])
    }
    
    override func subscribeToViewModel(_ viewModel: SiteInfoViewModel) {
        
        //MARK: Present navigation alert
        subscribe(to: \.$navigationAlert) { [unowned self] navigationAlert in
            guard let navigationAlert = navigationAlert else { return }
            present(navigationAlert, animated: true, completion: nil)
        }
        
        //MARK: Floating panel state changed
        subscribe(to: \.$floatingPanelState) { state in
            guard let state = state else { return }
            UIView.animateOnMain(withDuration: Constants.General.animationDuration) { [weak self] in
                self?.currencyExchangeView.translucent(state == .full ? 1 : 0)
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func goButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            viewModel.openMapButtonAction()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            viewModel.handleBackButtonTapped()
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

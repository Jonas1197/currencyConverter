//
//  ConverterPanelViewController.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 05/07/2022.
//

import UIKit
import NotSwiftUI

final class ConverterPanelViewController: BaseViewController<ConverterPanelViewModel> {

    @IBOutlet weak var titleLabel:                 UILabel!
    @IBOutlet weak var trailingButton:             UIButton!
    @IBOutlet weak var leadingButton:              UIButton!
    @IBOutlet weak var arrowsImageView:            UIImageView!
    @IBOutlet weak var upperTextField:             UITextField!
    @IBOutlet weak var lowerTextField:             UITextField!
    @IBOutlet weak var findConversionStoresButton: UIButton!
    @IBOutlet weak var currencyLastUpdatedLabel:   UILabel!
    
    private var textFieldContainer: UITextField!
    private var currencyPicker:     UIPickerView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = [trailingButton, leadingButton, upperTextField, lowerTextField, findConversionStoresButton].map { $0!.rounded($0!.frame.height / 4)}
    }
    
    //MARK: - SetUp
    private func setUp() {
        _ = [trailingButton, leadingButton].map {
            $0?.shadowed(with: .black, offset: .init(width: 0, height: 2), radius: 12, 0.1)
                .attributedPlaceholder("Tap to enter", attributes: [.font : Constants.Font.regular, .foregroundColor : UIColor.white as Any])
        }
        
        configureCurrencyPicker()
        viewModel.updateCurrencyRatesDate()
    }
    
    override func subscribeToViewModel(_ viewModel: ConverterPanelViewModel) {
        
        //MARK: Leading button
        subscribe(to: \.$leadingCurrencyModel) { [unowned self] model in
            guard let model = model,
                  let title = model.Currency else { return }
            leadingButton.setTitle(title, for: .normal)
        }
        
        //MARK: Trailing button
        subscribe(to: \.$trailingCurrencyModel) { [unowned self] model in
            guard let model = model,
                  let title = model.Currency else { return }
            trailingButton.setTitle(title, for: .normal)
        }
        
        //MARK: Last updated date string
        subscribe(to: \.$lastUpdatedDateString) { [unowned self] dateString in
            guard let dateString = dateString else { return }
            configureCurrencyLastUpdatedLabel(dateString: dateString)
        }
    }
    
    private func configureCurrencyPicker() {
        textFieldContainer        = .init(frame: .zero)
        currencyPicker            = .init()
        currencyPicker.delegate   = viewModel
        currencyPicker.dataSource = viewModel
        view.addSubview(textFieldContainer)
        textFieldContainer.inputView = currencyPicker
    }
    
    private func configureCurrencyLastUpdatedLabel(dateString: String) {
        currencyLastUpdatedLabel.text = "\(Constants.Text.ratesLastUpdatedLabel)\(dateString)"
    }
    
    
    //MARK: - Actions
    @IBAction func upperButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            viewModel.selectedButtonTag = sender.tag
            viewModel.move(to: .full)
            textFieldContainer.becomeFirstResponder()
        }
    }
    
    @IBAction func lowerButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            viewModel.selectedButtonTag = sender.tag
            viewModel.move(to: .full)
            textFieldContainer.becomeFirstResponder()
        }
    }
    
    @IBAction func findConversionStoresButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            viewModel.delegate?.findConversionStores()
            view.endEditing(true)
            viewModel.move(to: .tip)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

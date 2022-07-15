//
//  ConverterPanelViewController.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 05/07/2022.
//

import UIKit
import NotSwiftUI

final class ConverterPanelViewController: BaseViewController<ConverterPanelViewModel> {

    @IBOutlet weak var titleLabel:                       UILabel!
    @IBOutlet weak var trailingButton:                   UIButton!
    @IBOutlet weak var leadingButton:                    UIButton!
    @IBOutlet weak var arrowsImageView:                  UIImageView!
    @IBOutlet weak var leadingTextField:                 UITextField!
    @IBOutlet weak var trailingTextField:                UITextField!
    @IBOutlet weak var findConversionStoresButton:       UIButton!
    @IBOutlet weak var currencyLastUpdatedLabel:         UILabel!
    @IBOutlet weak var tapToChooseCurrencyLabelLeading:  UILabel!
    @IBOutlet weak var tapToChooseCurrencyLabelTrailing: UILabel!
    
    private let currencyExchangeView = CurrencyExchangeView.instantiateFromNib()
    
    private var valueRetrieved = false
    private var textFieldContainer: UITextField!
    private var currencyPicker:     UIPickerView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = [trailingButton, leadingButton, leadingTextField, trailingTextField, findConversionStoresButton].map { $0!.rounded($0!.frame.height / 4) }
    }
    
    //MARK: - SetUp
    private func setUp() {
        _ = [trailingButton, leadingButton].map {
            $0?.shadowed(with: .black, offset: .init(width: 0, height: 2), radius: 12, 0.1)
                .attributedPlaceholder("Tap to enter", attributes: [.font : Constants.Font.regular, .foregroundColor : UIColor.white as Any])
                .adjustedFontSizeToFitWidth()
        }
        
        findConversionStoresButton
            .shadowed(with: .black, offset: .init(width: 0, height: 2), radius: 12, 0.3)
        
        configureCurrencyPicker()
        viewModel.updateCurrencyRatesDate()
        configureCurrencyExchangeView()
    }
    
    private func configureCurrencyExchangeView() {
        currencyExchangeView.translatesAutoresizingMaskIntoConstraints = false
        currencyExchangeView.configure(withModel: .init(valuesToConvert: UserManager.shared.currencyExchangeViewCurrencies))
        currencyExchangeView.invisible()
        view.addSubview(currencyExchangeView)
        NSLayoutConstraint.activate([
            currencyExchangeView.topAnchor.constraint(equalTo: findConversionStoresButton.bottomAnchor, constant: 42),
            currencyExchangeView.leadingAnchor.constraint(equalTo: findConversionStoresButton.leadingAnchor),
            currencyExchangeView.trailingAnchor.constraint(equalTo: findConversionStoresButton.trailingAnchor),
            currencyExchangeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -22)
        ])
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
        
        //MARK: Trailing text field update
        subscribe(to: \.$trailingTextFieldText) { [unowned self] text in
            guard let text = text else { return }
            updateTextField(leading: false, text: text)
        }
        
        //MARK: Leading text field update
        subscribe(to: \.$leadingTextFieldText) { [unowned self] text in
            guard let text = text else { return }
            updateTextField(leading: true, text: text)
        }
        
        //MARK: Keyboard has appeared
        subscribe(to: \.$keyboardAppeared) { [unowned self] appeared in
            guard let appeared = appeared else { return }
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) { [weak self] in
                    guard let self = self else { return }
                    _ = [self.findConversionStoresButton, self.currencyExchangeView].map { $0!.translucent(appeared ? 0 : 1) }
                }
            }
        }
        
        //MARK: Floating panel state changed
        subscribe(to: \.$floatingPanelState) { state in
            guard let state = state else { return }
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) { [unowned self] in
                    if let keyboardAppeared = viewModel.keyboardAppeared {
                        if !keyboardAppeared && state == .full {
                            self.currencyExchangeView.visible()
                        } else if !keyboardAppeared {
                            self.currencyExchangeView.translucent(state == .full ? 1 : 0)
                            _ = [tapToChooseCurrencyLabelLeading, tapToChooseCurrencyLabelTrailing, leadingButton, trailingButton, arrowsImageView, leadingTextField, trailingTextField, currencyLastUpdatedLabel, findConversionStoresButton].map { $0!.translucent((state == .half || state == .full) ? 1 : 0)}
                        }
                        
                    } else {
                        _ = [tapToChooseCurrencyLabelLeading, tapToChooseCurrencyLabelTrailing, leadingButton, trailingButton, arrowsImageView, leadingTextField, trailingTextField, currencyLastUpdatedLabel, findConversionStoresButton].map { $0!.translucent((state == .half || state == .full) ? 1 : 0)}
                        self.currencyExchangeView.translucent(state == .full ? 1 : 0)
                    }
                }
            }
        }
    }
    
    private func updateTextField(leading: Bool, text: String) {
        valueRetrieved = true
        
        if leading {
            leadingTextField.text = text
        } else {
            trailingTextField.text = text
        }
        
        valueRetrieved = false
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
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) { [weak self] in
            self?.currencyLastUpdatedLabel
                .invisible()
                .setText("\(Constants.Text.ratesLastUpdatedLabel)\(dateString)")
            
        } completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) { [weak self] in
                self?.currencyLastUpdatedLabel.visible()
            }
        }
    }
    
    private func emptyTextFields() {
        _ = [leadingTextField, trailingTextField].map { $0?.setText("") }
    }
    
    private func animateWhitenButtons() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) { [weak self] in
                _ = [self?.trailingButton, self?.leadingButton].map {
                    $0?.backgroundColored(.white)
                        .coloredText(Constants.Colors.deepBlue!)
                }
            }
        }
    }
    
    private func animateButton(_ button: UIButton, leading: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) { [weak self] in
                button
                    .backgroundColored(Constants.Colors.deepBlue!)
                    .coloredText(.white)
                
                if leading {
                    self?.trailingButton
                        .backgroundColored(.white)
                        .coloredText(Constants.Colors.deepBlue!)
                } else {
                    self?.leadingButton
                        .backgroundColored(.white)
                        .coloredText(Constants.Colors.deepBlue!)
                }
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func trailingButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) { [weak self] in
                    sender.titleLabel?.adjustedFontSizeToFitWidth()
                    sender
                        .backgroundColored(Constants.Colors.deepBlue!)
                        .coloredText(.white)
                    
                    self?.leadingButton
                        .backgroundColored(.white)
                        .coloredText(Constants.Colors.deepBlue!)
                }
            }
            
            viewModel.selectedButtonTag = sender.tag
            viewModel.move(to: .full)
            textFieldContainer.becomeFirstResponder()
            emptyTextFields()
        }
    }
    
    @IBAction func leadingButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            animateButton(sender, leading: true)
            viewModel.selectedButtonTag = sender.tag
            viewModel.move(to: .full)
            textFieldContainer.becomeFirstResponder()
            emptyTextFields()
        }
    }
    
    @IBAction func findConversionStoresButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            animateButton(sender, leading: false)
            viewModel.delegate?.findConversionStores()
            view.endEditing(true)
            viewModel.move(to: .tip)
        }
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if !valueRetrieved {
            if let text = sender.text,
               text != "" {
                viewModel.convert(valueFromTextField: sender)
            } else {
                if sender.tag == 0 {
                    trailingTextField.text = ""
                } else {
                    leadingTextField.text = ""
                }
            }
        }
    }
    
    @IBAction func textFieldEditingBegin(_ sender: UITextField) {
        animateWhitenButtons()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        animateWhitenButtons()
        if viewModel.floatingPanel?.state == .full {
            viewModel.floatingPanel?.move(to: .half, animated: true)
        }
    }
}

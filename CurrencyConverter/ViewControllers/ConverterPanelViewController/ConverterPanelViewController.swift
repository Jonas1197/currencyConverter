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
    
    private var currencyExchangeView = CurrencyExchangeView.instantiateFromNib()
    
    private var valueRetrieved                 = false
    private var currencyExchangeViewConfigured = false
    private var textFieldContainer: UITextField!
    
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
        
        viewModel.updateCurrencyRatesDate()
        configureCurrencyExchangeView()
        
        arrowsImageView
            .targeted(self, action: #selector(arrowsImageViewTapped(_:)))
            .isUserInteractionEnabled = true
        
        findConversionStoresButton.titleLabel?.adjustedFontSizeToFitWidth()
        
        localize()
    }
    
    private func localize() {
        currencyLastUpdatedLabel.text = Constants.LocalizedText.converterVC_ratesBeingUpdates.localized()
        titleLabel.text = Constants.LocalizedText.converterVC_titleLabel.localized()
        _ = [tapToChooseCurrencyLabelLeading, tapToChooseCurrencyLabelTrailing].map { $0?.text = Constants.LocalizedText.converterVC_tapToChoose.localized() }
        
        _ = [leadingTextField, trailingTextField].map { $0?.placeholder = Constants.LocalizedText.converterVC_tapToEnterPlaceholder.localized() }
        
        findConversionStoresButton.setText(Constants.LocalizedText.converterVC_findButton.localized() )
    }
    
    private func configureCurrencyExchangeView() {
        if !currencyExchangeViewConfigured {
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
            
            currencyExchangeViewConfigured = true
        }
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
            currencyExchangeView.removeFromSuperview()
            currencyExchangeView = .instantiateFromNib()
            currencyExchangeViewConfigured = false
            configureCurrencyExchangeView()
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
            
            UIView.animateOnMain(withDuration: Constants.General.animationDuration) { [weak self] in
                guard let self = self else { return }
                _ = [self.findConversionStoresButton, self.currencyExchangeView].map { $0!.translucent(appeared ? 0 : 1) }
            }
        }
        
        //MARK: Floating panel state changed
        subscribe(to: \.$floatingPanelState) { [weak self] state in
            guard let self  = self,
                  let state = state else { return }
            
            UIView.animateOnMain(withDuration: Constants.General.animationDuration) {
                let viewsToAnimate = [self.tapToChooseCurrencyLabelLeading, self.tapToChooseCurrencyLabelTrailing, self.leadingButton, self.trailingButton, self.leadingTextField, self.trailingTextField, self.currencyLastUpdatedLabel, self.findConversionStoresButton]
                
                if let keyboardAppeared = viewModel.keyboardAppeared {
                    if !keyboardAppeared && state == .full {
                        self.currencyExchangeView.visible()
                    } else if !keyboardAppeared {
                        self.currencyExchangeView.translucent(state == .full ? 1 : 0)
                        _ = viewsToAnimate.map { $0!.translucent((state == .half || state == .full) ? 1 : 0)}
                        self.arrowsImageView.translucent((state == .half || state == .full) ? 1 : 0)
                    }
                    
                } else {
                    _ = viewsToAnimate.map { $0!.translucent((state == .half || state == .full) ? 1 : 0)}
                    self.arrowsImageView.translucent(state == .tip ? 0 : 1)
                    self.currencyExchangeView.translucent(state == .full ? 1 : 0)
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
    
    private func configureCurrencyLastUpdatedLabel(dateString: String) {
        UIView.animateOnMain(withDuration: Constants.General.animationDuration) { [weak self] in
            self?.currencyLastUpdatedLabel
                .invisible()
                .setText("\(Constants.LocalizedText.converterVC_currencyRates.localized()) \(dateString)")
        } didFinish: { [weak self] _ in
            UIView.animateOnMain(withDuration: Constants.General.animationDuration) {
                self?.currencyLastUpdatedLabel.visible()
            }
        }
    }
    
    private func emptyTextFields() {
        _ = [leadingTextField, trailingTextField].map { $0?.setText("") }
    }
    
    private func animateWhitenButtons() {
        UIView.animateOnMain(withDuration: Constants.General.animationDuration) { [weak self] in
            _ = [self?.trailingButton, self?.leadingButton].map {
                $0?.backgroundColored(.white)
                    .coloredText(Constants.Colors.deepBlue!)
            }
        }
    }
    
    //MARK: Animation buttons tapped
    private func animateButton(_ button: UIButton, leading: Bool) {
        UIView.animateOnMain(withDuration: Constants.General.animationDuration) { [weak self] in
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
    
    //MARK: - Actions
    
    //MARK: Trrailing button tapped
    @IBAction func trailingButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            
            UIView.animateOnMain(withDuration: Constants.General.animationDuration) { [weak self] in
                sender.titleLabel?.adjustedFontSizeToFitWidth()
                sender
                    .backgroundColored(Constants.Colors.deepBlue!)
                    .coloredText(.white)
                
                self?.leadingButton
                    .backgroundColored(.white)
                    .coloredText(Constants.Colors.deepBlue!)
            }
            
            viewModel.selectedButtonTag = sender.tag
            viewModel.move(to: .full)
            
            dismiss(animated: true)
            viewModel.delegate?.presentCurrencyPicker(leading: false)
            emptyTextFields()
        }
    }
    
    //MARK: Leading button tapped
    @IBAction func leadingButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            animateButton(sender, leading: true)
            viewModel.selectedButtonTag = sender.tag
            viewModel.move(to: .full)
            dismiss(animated: true)
            viewModel.delegate?.presentCurrencyPicker(leading: true)
            emptyTextFields()
        }
    }
    
    //MARK: Find conversion stores button
    @IBAction func findConversionStoresButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation { [unowned self] in
            animateButton(sender, leading: false)
            viewModel.delegate?.findConversionStores()
            view.endEditing(true)
            viewModel.move(to: .tip)
        }
    }
    
    //MARK: Textfield editing chagned
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        
        if !valueRetrieved {
            if let text = sender.text,
               text != "" {
                var editedText = text
                
                if text.contains(",") {
                    editedText = editedText.replacingOccurrences(of: ",", with: ".")
                }
                
                let stringElements = Array(editedText)
                var numberOfDots = 0
                _ = stringElements.map {
                    numberOfDots += ($0 == ".") ? 1 : 0
                }
                
                if numberOfDots > 1 {
                    editedText.removeLast()
                }
                
                textFieldEditingAllowed(sender, text: editedText)
                
            } else {
                if sender.tag == 0 {
                    trailingTextField.text = ""
                    viewModel.trailingTextFieldText = ""
                    
                } else {
                    leadingTextField.text = ""
                    viewModel.leadingTextFieldText = ""
                }
                
                textFieldEditingAllowed(sender, text: "")
            }
        }
    }
    
    private func textFieldEditingAllowed(_ sender: UITextField, text: String) {
        if sender.tag == 0 {
            viewModel.leadingTextFieldText = text
        } else {
            viewModel.trailingTextFieldText = text
        }
        
        viewModel.convert(valueFromTextField: sender)
    }
    
    //MARK: Textfield editing begin
    @IBAction func textFieldEditingBegin(_ sender: UITextField) {
        animateWhitenButtons()
    }
    
    @objc private func arrowsImageViewTapped(_ sender: UITapGestureRecognizer) {
        arrowsImageView.actionWithSpringAnimation {
            self.viewModel.switchCurrencyModels()
        }
    }
    
    //MARK: Touches began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        animateWhitenButtons()
        
        if touches.first?.view != arrowsImageView {
            if viewModel.floatingPanel?.state == .full {
                viewModel.floatingPanel?.move(to: .half, animated: true)
            }
        }
    }
}

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
    }
    
    override func subscribeToViewModel(_ viewModel: ConverterPanelViewModel) {
        
        //MARK: Left button title
        subscribe(to: \.$leadingButtonTitle) { [unowned self] title in
            guard let title = title else { return }
            leadingButton.setTitle(title, for: .normal)
        }
        
        //MARK: Right button title
        subscribe(to: \.$trailingButtonTitle) { [unowned self] title in
            guard let title = title else { return }
            trailingButton.setTitle(title, for: .normal)
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

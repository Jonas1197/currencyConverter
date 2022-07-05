//
//  ConverterPanelViewController.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 05/07/2022.
//

import UIKit

final class ConverterPanelViewController: BaseViewController<ConverterPanelViewModel> {

    @IBOutlet weak var titleLabel:      UILabel!
    @IBOutlet weak var upperButton:     UIButton!
    @IBOutlet weak var lowerButton:     UIButton!
    @IBOutlet weak var arrowsImageView: UIImageView!
    @IBOutlet weak var upperTextField:  UITextField!
    @IBOutlet weak var lowerTextField:  UITextField!
    
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = [upperButton, lowerButton].map { $0!.rounded($0!.frame.height / 4)}
    }
    
    //MARK: - SetUp
    private func setUp() {
        arrowsImageView.transform = .init(rotationAngle: .pi / 2)
        _ = [upperButton, lowerButton].map {
            $0?.shadowed(with: .black, offset: .init(width: 0, height: 2), radius: 12, 0.1)
                .attributedPlaceholder("Tap to enter", attributes: [.font : Constants.Font.regular, .foregroundColor : UIColor.white as Any])
        }
        
        _ = [upperTextField, lowerTextField].map {
            $0?.rounded($0!.frame.height / 4)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func upperButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation {
            //
        }
    }
    
    @IBAction func lowerButtonTapped(_ sender: UIButton) {
        sender.actionWithSpringAnimation {
            //
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

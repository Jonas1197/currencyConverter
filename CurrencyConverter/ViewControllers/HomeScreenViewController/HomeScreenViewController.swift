//
//  HomeScreenViewController.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 01/07/2022.
//

import UIKit
import NotSwiftUI

final class HomeScreenViewController: BaseViewController<HomeScreenViewModel> {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainPanelView:       UIView!
    @IBOutlet weak var historyLabel:        UILabel!
    
    private var converterVstackBottomConstraint: NSLayoutConstraint!
    private var convertInputsVstack:             UIView!
    private var convertFromView:                 InputView!
    private var convertToView:                   InputView!
    
    private var historyView: QuickGlanceView!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainPanelView.roundCorners(to: .custom(mainPanelView.frame.height / 14))
        mainPanelView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    
    //MARK: - SetUp
    private func setUp() {
        configureConvertToView()
        configureHistoryView()
    }
    
    
    override func subscribeToViewModel(_ viewModel: HomeScreenViewModel) {
        
        //MARK: Keyboard toggled
        subscribe(to: \.$isKeyboardShowing) { [unowned self] isShowing in
            guard let isShowing = isShowing else { return }
            UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
                historyView.translucent(isShowing ? 0 : 1)
                converterVstackBottomConstraint.constant = isShowing ? -330 : -32
                view.layoutIfNeeded()
            }
        }
    }
    
    private func configureConvertToView() {
        convertToView = .instantiateFromNib()
        convertFromView = .instantiateFromNib()
        
        convertInputsVstack = [convertFromView, convertToView].vstacked(spacing: 20, alignment: .fill, distribution: .fillProportionally)
        
        view.addSubview(convertInputsVstack)
        
        converterVstackBottomConstraint = convertInputsVstack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
        NSLayoutConstraint.activate([
            convertInputsVstack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            convertInputsVstack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            converterVstackBottomConstraint,
            convertToView.heightAnchor.constraint(equalToConstant: 100),
            convertFromView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        convertToView.configure(withModel: .example)
        convertFromView.configure(withModel: .example)
        
        viewModel.listenToKeyboardEvents()
    }
    
    private func configureHistoryView() {
        historyView = .instantiateFromNib()
        historyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(historyView)
        NSLayoutConstraint.activate([
            historyView.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant:  16),
            historyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyView.bottomAnchor.constraint(equalTo: convertInputsVstack.topAnchor, constant: -16)
        ])
        
        historyView.configure()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

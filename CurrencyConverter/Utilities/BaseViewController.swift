//
//  BaseViewController.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 01/07/2022.
//

import UIKit
import Combine

class BaseViewController<ViewModel>: UIViewController, BindableViewController {
    
    var viewModel: ViewModel
    
    var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToViewModel(self.viewModel)
    }
    
    func subscribeToViewModel(_ viewModel: ViewModel) {
        
    }
    
    func subscribe<P: Publisher, T: Publisher>(to keyPath: KeyPath<ViewModel, P>,
                                               transform: (P) -> T,
                                               handler: @escaping (T.Output) -> Void) where P.Failure == Never, T.Failure == Never {
        
        transform(viewModel[keyPath: keyPath]).sink {
            handler($0)
        }
        .store(in: &cancellables)
    }
}

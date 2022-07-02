//
//  BindableViewController.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 01/07/2022.
//

import UIKit
import Combine

protocol BindableViewController: UIViewController {
    associatedtype ViewModel
    var viewModel: ViewModel { get set }
    var cancellables: Set<AnyCancellable> { get set }
    func subscribe<P: Publisher>(to keyPath: KeyPath<ViewModel, P>, handler: @escaping (P.Output) -> Void) where P.Failure == Never
}

extension BindableViewController {
    func subscribe<P: Publisher>(to keyPath: KeyPath<ViewModel, P>, handler: @escaping (P.Output) -> Void) where P.Failure == Never {
        viewModel[keyPath: keyPath].sink { value in
            handler(value)
        }
        .store(in: &cancellables)
    }
}

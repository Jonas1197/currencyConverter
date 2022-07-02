//
//  Subscribable.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 02/07/2022.
//

import UIKit
import Combine

protocol Subscribable {
    var cancellable: [AnyCancellable] { get set }
    
    mutating func subscribe<P: Publisher>(to path: P, handler: @escaping (P.Output) -> Void) where P.Failure == Never
}


extension Subscribable {
    mutating func subscribe<P: Publisher>(to path: P, handler: @escaping (P.Output) -> Void) where P.Failure == Never {
        path.sink { value in
            handler(value)
        }
        .store(in: &cancellable)
    }
}

//
//  HomeScreenViewModel.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 01/07/2022.
//

import UIKit
import Combine

protocol HomeScreenOutput: AnyObject {
    
}

final class HomeScreenViewModel: NSObject {
    weak var output: HomeScreenOutput?
    
    init(output: HomeScreenOutput?) {
        super.init()
        self.output = output
    }
}

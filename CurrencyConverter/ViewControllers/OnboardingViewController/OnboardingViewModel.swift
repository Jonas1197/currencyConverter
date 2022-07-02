//
//  OnboardingViewModel.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 01/07/2022.
//

import UIKit

protocol OnboardingOutput: AnyObject {
    
}

final class OnboardingViewModel: NSObject {
    weak var output: OnboardingOutput?
    
    init(output: OnboardingOutput?) {
        super.init()
        self.output = output
    }
}

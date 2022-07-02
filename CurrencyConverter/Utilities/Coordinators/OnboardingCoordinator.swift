//
//  OnboardingCoordinator.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 01/07/2022.
//

import UIKit
import EKSwiftSuite

protocol OnboardingCoordinatorOutput: AnyObject {
    func goToHomescreen()
}

final class OnboardingCoordinator: BaseCoordinator<UIViewController> {
    weak var output: OnboardingCoordinatorOutput?
    
    let onboardingViewController: OnboardingViewController
    
    init(output: OnboardingCoordinatorOutput?) {
        let viewModel = OnboardingViewModel(output: nil)
        self.onboardingViewController = .init(viewModel: viewModel)
        super.init(rootViewController: onboardingViewController)
        viewModel.output = self
    }
}


//MARK: - OnboardingOutput
extension OnboardingCoordinator: OnboardingOutput {
    func didFinishOnboarding() {
        output?.goToHomescreen()
    }
}

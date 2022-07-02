//
//  MainCoordinator.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 01/07/2022.
//

import UIKit
import EKSwiftSuite

final class MainCoordinator: BaseCoordinator<UIViewController> {
    
    private var window: UIWindow
    
    var childCoordinator: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    //MARK: ViewControllers
    var homeScreenViewController: HomeScreenViewController!
    
    //MARK: - Lifecycle
    init(windowScene: UIWindowScene) {
        self.window = UIWindow(windowScene: windowScene)
        
        if !UserManager.shared.didSeeOnboarding {
            let coordinator      = OnboardingCoordinator(output: nil)
            navigationController = .init(rootViewController: coordinator.rootViewController)
            
            super.init(rootViewController: coordinator.rootViewController)
            append(child: coordinator)
            coordinator.output = self
            window.rootViewController = navigationController
            
        } else {
            homeScreenViewController  = .init(viewModel: .init(output: nil))
            navigationController      = .init(rootViewController: homeScreenViewController)
            window.rootViewController = navigationController
            super.init(rootViewController: homeScreenViewController)
            homeScreenViewController.viewModel.output = self
        }
    }
    
    override func start() {
        window.makeKeyAndVisible()
    }
    
    func homescreen() {
        homeScreenViewController = .init(viewModel: .init(output: self))
        navigationController.pushViewController(homeScreenViewController, animated: true)
    }
    
}

//MARK: - OnboardingOutput
extension MainCoordinator: OnboardingCoordinatorOutput {
    func goToHomescreen() {
        homescreen()
    }
}

//MARK: - HomeScreenOutput
extension MainCoordinator: HomeScreenOutput {
    
}

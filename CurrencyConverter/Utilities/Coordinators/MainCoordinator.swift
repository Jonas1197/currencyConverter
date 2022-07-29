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
    var settingsViewController:   SettingsViewController!
    
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
        fetchCurrencyData()
    }
    
    private func fetchCurrencyData() {
        let lastUpdatedTimestamp = UserManager.shared.currencyUpdatedTimestamp
        if !lastUpdatedTimestamp.isEmpty,
           let timeInterval = TimeInterval(lastUpdatedTimestamp),
           Date().timeIntervalSince1970 - timeInterval < (24 * 60 * 60) {
            print("\n~~> Currency data not older than one day.")
            decodeSavedCurrencyData()
        } else {
            print("\n~~> Updating currency data.")
            updateCurrencyData()
        }
    }
    
    private func updateCurrencyData() {
        Task {
            guard let parsedCurrenciesData      = await NetworkManager.shared.fetchWorldCurrencies(),
                  let parsedConversionRatesData = await NetworkManager.shared.updateConversionRates() else { return }
            
            do {
                let currenciesListData  = try JSONEncoder().encode(parsedCurrenciesData)
                let conversionRatesData = try JSONEncoder().encode(parsedConversionRatesData)
                
                setCurrencyList(parsedCurrenciesData, accordingToAvailableRates: parsedConversionRatesData)
//                UserManager.shared.currencyList     = parsedCurrenciesData
                UserManager.shared.currencyListData = currenciesListData

                UserManager.shared.conversionRates     = parsedConversionRatesData
                UserManager.shared.conversionRatesData = conversionRatesData
                
                let timestamp = "\(Date().timeIntervalSince1970)"
                UserManager.shared.currencyUpdatedTimestamp = timestamp
                
            } catch {
                print("\n~~> Couldn't encode parsed data: \(error.localizedDescription)")
            }
        }
    }
    
    private func decodeSavedCurrencyData() {
        let currenciesData = UserManager.shared.currencyListData
        let conversionRatesData = UserManager.shared.conversionRatesData
        
        if currenciesData.count != Data().count || conversionRatesData.count != Data().count {
    
            do {
                let decodedCurrencyData = try JSONDecoder().decode([CurrencyModel].self, from: currenciesData)
                let decodedConversionRatesData = try JSONDecoder().decode(ConversionModel.self, from: conversionRatesData)
                
                UserManager.shared.conversionRates = decodedConversionRatesData
                setCurrencyList(decodedCurrencyData, accordingToAvailableRates: decodedConversionRatesData)
//                UserManager.shared.currencyList    = decodedCurrencyData
            } catch {
                print("\n~~> Couldn't decode parsed data: \(error.localizedDescription)")
            }
        }
    
    }
    
    private func setCurrencyList(_ list: [CurrencyModel], accordingToAvailableRates rates: ConversionModel) {
        var filtered: [CurrencyModel] = []
        
        for item in list {
            if !filtered.contains(where: { $0.AlphabeticCode == item.AlphabeticCode }),
               rates.conversion_rates.contains(where: { $0.key == item.AlphabeticCode }) {
                filtered.append(item)
            }
        }
        
        filtered = filtered.sorted(by: {
            if let firstItemCurrency = $0.Currency,
               let secondItemCurrency = $1.Currency {
                return firstItemCurrency < secondItemCurrency
            }
            
            return false
        })
        
        UserManager.shared.currencyList = filtered
    }
    
    func homescreen() {
        homeScreenViewController = .init(viewModel: .init(output: self))
        navigationController.pushViewController(homeScreenViewController, animated: true)
    }
    
    func settings() {
        settingsViewController = .init(viewModel: .init(self))
        navigationController.present(settingsViewController, animated: true, completion: nil)
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
    func presentsSettings() {
        settings()
    }
}

//MARK: - SettingsOutput
extension MainCoordinator: SettingsOutput {
    func settingsDidDisappear() {
        homeScreenViewController.configureFloatingPanel()
    }
}

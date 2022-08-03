//
//  CurrencySelectorViewModel.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 30/07/2022.
//

import UIKit
import Combine

protocol CurrencySelectorOutput: AnyObject {
    func currencySelectorDidDisappear()
    func currencySelectorDidSelectCurrency(_ currencyName: CurrencyModel, leading: Bool)
}

final class CurrencySelectorViewModel: NSObject {
    weak var output: CurrencySelectorOutput?
    
    private var currencies: [CurrencyModel] = UserManager.shared.currencyList { didSet {
        
    }}
    
    private var selectingLeadingCurrency = false
    
    @Published var reloadsTableView: Bool?
    
    //MARK: - Lifecycle
    init(_ output: CurrencySelectorOutput, leading: Bool) {
        super.init()
        self.output = output
        self.selectingLeadingCurrency = leading
    }
    
    func disappeared() {
        output?.currencySelectorDidDisappear()
    }
    
    private func saveSelectedCurrencyModel(_ model: CurrencyModel) {
        guard let data = try? JSONEncoder().encode(model) else { return }
        
        if selectingLeadingCurrency {
            UserManager.shared.selectedLeadingCurrencyModelData  = data
        } else {
            UserManager.shared.selectedTrailingCurrencyModelData = data
        }
    }
}

//MARK: - UITableViewController
extension CurrencySelectorViewModel: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.currencyCell, for: indexPath) as? CurrencySelectorTableViewCell else { return .init() }
        cell.currencyName = currencies[indexPath.row].Currency
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCurrencyModel = currencies[indexPath.row]
        saveSelectedCurrencyModel(selectedCurrencyModel)
        output?.currencySelectorDidSelectCurrency(selectedCurrencyModel, leading: selectingLeadingCurrency)
    }
    
}

//MARK: - UISearchBarDelegate
extension CurrencySelectorViewModel: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\n~~> Search ternms: \(searchText)")
        if searchText.isEmpty {
            self.currencies = UserManager.shared.currencyList
        } else {
            self.currencies = UserManager.shared.currencyList.filter {
                if let currencyName = $0.Currency {
                    return currencyName.contains(searchText)
                } else {
                    return false
                }
            }
        }
       
        
        reloadsTableView = true
    }
}


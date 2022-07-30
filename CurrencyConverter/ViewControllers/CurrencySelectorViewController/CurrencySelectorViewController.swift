//
//  CurrencySelectorViewController.swift
//  CurrencyConverter
//
//  Created by Jonas Gamburg on 30/07/2022.
//

import UIKit

final class CurrencySelectorViewController: BaseViewController<CurrencySelectorViewModel> {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.disappeared()
    }
    
    override func subscribeToViewModel(_ viewModel: CurrencySelectorViewModel) {
        subscribe(to: \.$reloadsTableView) { [unowned self] reloads in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - SetUp
    private func setUp() {
        tableView.register(.init(nibName: String(describing: CurrencySelectorTableViewCell.self), bundle: nil), forCellReuseIdentifier: Constants.Identifier.currencyCell)
        tableView.delegate   = viewModel
        tableView.dataSource = viewModel
        searchBar.delegate   = viewModel
    }
    
    //MARK: - Actions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

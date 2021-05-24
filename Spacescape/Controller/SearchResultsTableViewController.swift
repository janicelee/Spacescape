//
//  SearchResultsTableViewController.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-22.
//

import UIKit

protocol SearchResultsTableViewControllerDelegate: class {
    func didSelectSearchItem(searchItem: SearchItem)
}

class SearchResultsTableViewController: UITableViewController {
    
    weak var delegate: SearchResultsTableViewControllerDelegate?
    private var searchItems = [SearchItem]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private let rowHeight: CGFloat = 134

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = rowHeight
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseID)
    }
    
    func setSearchItems(_ items: [SearchItem]) {
        self.searchItems = items
    }
    
    // Clears list of SearchItem results
    func clearResults() {
        searchItems.removeAll()
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseID, for: indexPath) as! SearchResultTableViewCell
        let result = searchItems[indexPath.row]
        cell.set(result)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchItem = searchItems[indexPath.row]
        delegate?.didSelectSearchItem(searchItem: searchItem)
    }
}

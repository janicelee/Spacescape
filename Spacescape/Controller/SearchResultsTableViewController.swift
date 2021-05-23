//
//  SearchResultsTableViewController.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-22.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {

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
        
        NASAClient.shared.search(for: "moon", page: 1) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let searchResult):
                self.searchItems = searchResult.collection.items
            case .failure(let error):
                // TODO: handle error case
                print(error.rawValue)
            }
        }
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
        let destination = InfoViewController(searchItem: searchItem)
        navigationController?.pushViewController(destination, animated: true)
    }
}

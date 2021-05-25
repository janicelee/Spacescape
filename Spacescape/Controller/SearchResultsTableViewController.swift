//
//  SearchResultsTableViewController.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-22.
//

import UIKit

protocol SearchResultsTableViewControllerDelegate: class {
    func didSelectSearchItem(searchItem: SearchItem)
    func getNextPage()
}

class SearchResultsTableViewController: UITableViewController {
    
    private let rowHeight: CGFloat = 134
    
    weak var delegate: SearchResultsTableViewControllerDelegate?
    private var searchItems = [SearchItem]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var totalHits = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = rowHeight
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseID)
        tableView.separatorStyle = .none
    }
    
    func appendResults(_ searchResult: SearchResult) {
        self.searchItems.append(contentsOf: searchResult.collection.items)
        self.totalHits = searchResult.collection.metadata.totalHits
    }
    
    // Clears list of SearchItem results
    func clearResults() {
        searchItems.removeAll()
        NASAClient.shared.clearImageCache()
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseID, for: indexPath) as! SearchResultTableViewCell
        let result = searchItems[indexPath.row]
        cell.set(result)
        
        // When user gets near the end, call on delegate to fetch the next page of results
        if indexPath.row == searchItems.count - 4 && searchItems.count < totalHits {
            delegate?.getNextPage()
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchItem = searchItems[indexPath.row]
        delegate?.didSelectSearchItem(searchItem: searchItem)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! SearchResultTableViewCell
        cell.setImageToPlaceholder()
    }
}

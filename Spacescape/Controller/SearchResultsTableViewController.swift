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
    private let emptyStateLabel = UILabel()
    private let rowHeight: CGFloat = 134
    
    private var totalHits = 0
    weak var delegate: SearchResultsTableViewControllerDelegate?
    
    private var searchItems = [SearchItem]() {
        didSet { updateUI() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        tableView.rowHeight = rowHeight
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseID)
        tableView.separatorStyle = .none
        
        view.addSubview(emptyStateLabel)
        emptyStateLabel.text = "No results to display"
        emptyStateLabel.font = UIFont.systemFont(ofSize: FontSize.large, weight: .light)
        
        let padding: CGFloat = 50
        
        emptyStateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(padding)
            make.centerX.equalToSuperview()
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            
            if self.searchItems.isEmpty {
                UIView.transition(with: self.emptyStateLabel, duration: 0.3, options: .transitionCrossDissolve) {
                    self.emptyStateLabel.isHidden = false
                }
            } else {
                self.emptyStateLabel.isHidden = true
            }
        }
    }
    
    func appendResults(_ searchResult: SearchResult) {
        self.searchItems.append(contentsOf: searchResult.collection.items)
        self.totalHits = searchResult.collection.metadata.totalHits
    }
    
    // Clears list of results
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
        
        // When user gets near the end of the list, call on delegate to fetch the next page of results
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

//
//  SearchViewController.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var searchController: UISearchController!
    private var resultsTableViewController: SearchResultsTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        resultsTableViewController = SearchResultsTableViewController()
        resultsTableViewController.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableViewController)
        searchController.searchBar.placeholder = "Search NASA Images"
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func getSearchResults(for text: String) {
        NASAClient.shared.search(for: text, page: 1) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let searchResult):
                self.resultsTableViewController.searchItems = searchResult.collection.items
            case .failure(let error):
                // TODO: handle error
                print(error.rawValue)
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            getSearchResults(for: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsTableViewController.clearResults()
    }
}

// MARK: - SearchResultsTableViewControllerDelegate

extension SearchViewController: SearchResultsTableViewControllerDelegate {
    
    func didSelectSearchItem(searchItem: SearchItem) {
        let infoViewController = InfoViewController(searchItem: searchItem)
        navigationController?.pushViewController(infoViewController, animated: true)
    }
}

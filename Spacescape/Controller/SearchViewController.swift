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
    private var searchText = ""
    private var page = 1

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
    
    private func getSearchResults(for text: String, page: Int) {
        NASAClient.shared.search(for: text, page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let searchResult):
                self.resultsTableViewController.appendResults(searchResult)
            case .failure(let error):
                self.presentErrorAlertOnMainThread(message: ErrorMessage.generic)
                print(error)
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            self.searchText = searchText
            getSearchResults(for: searchText, page: page)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsTableViewController.clearResults()
        page = 1
    }
}

// MARK: - SearchResultsTableViewControllerDelegate

extension SearchViewController: SearchResultsTableViewControllerDelegate {
    
    func didSelectSearchItem(searchItem: SearchItem) {
        let infoViewController = InfoViewController(searchItem: searchItem)
        navigationController?.pushViewController(infoViewController, animated: true)
    }
    
    func getNextPage() {
        page += 1
        
        // Only allow requests for pages <= 100, since pages above 100 return an error
        if page <= 100 {
            getSearchResults(for: searchText, page: page)
        }
    }
}

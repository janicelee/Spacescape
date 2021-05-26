//
//  NASAClient.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-22.
//

import UIKit

class NASAClient {
    static let shared = NASAClient()
    private let cache = NSCache<NSString, UIImage>()
    private let baseURL = "https://images-api.nasa.gov"
    
    private init() {}
    
    private func sendRequest(urlComponents: URLComponents, completed: @escaping (Result<Data, NASAClientError>) -> ()) {
        guard let url = urlComponents.url else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                completed(.failure(.unableToCompleteRequest))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 400 {
                    completed(.failure(.invalidRequest))
                } else if response.statusCode == 404 {
                    completed(.failure(.notFound))
                } else if response.statusCode == 500 || response.statusCode == 502 || response.statusCode == 503 || response.statusCode == 504 {
                    completed(.failure(.serverError))
                }
            } else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            completed(.success(data))
        }
        task.resume()
    }
    
    func search(for searchText: String, page: Int, completed: @escaping (Result<SearchResult, NASAClientError>) -> ()) {
        let queryItems = [URLQueryItem(name: "media_type", value: "image"),
                          URLQueryItem(name: "q", value: searchText),
                          URLQueryItem(name: "page", value: String(page))]
        var urlComps = URLComponents(string: baseURL)!
        urlComps.path = "/search"
        urlComps.queryItems = queryItems
        
        sendRequest(urlComponents: urlComps) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.dateDecodingStrategy = .iso8601
                    let searchResult = try decoder.decode(SearchResult.self, from: data)
                    completed(.success(searchResult))
                } catch let error {
                    print(error)
                    completed(.failure(.unableToParse))
                }
            case .failure(let error):
                print("Error while sending search request for search text: \(searchText), page: \(page)")
                completed(.failure(error))
            }
        }
    }
    
    // Downloads image from given URL string
    // Completion handler has void return since images have placeholders
    func downloadImage(from urlString: String, completed: @escaping (UIImage) -> ()) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard var urlComps = URLComponents(string: urlString) else {
            print("Malformed URL")
            return
        }
        
        // Force all urls to use https
        urlComps.scheme = "https"
        
        sendRequest(urlComponents: urlComps) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                self.cache.setObject(image, forKey: cacheKey)
                completed(image)
            case .failure(let error):
                print("Failed to download image from: \(urlString), error: \(error.rawValue)")
            }
        }
    }
    
    // Unpacks image collection.json URI found in SearchItem.href
    func unpackImageCollection(from urlString: String, completed: @escaping ([String]) -> ()) {
        guard let urlComps = URLComponents(string: urlString) else {
            print("Malformed URL")
            return
        }
        
        sendRequest(urlComponents: urlComps) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let imageLinks = try decoder.decode([String].self, from: data)
                    completed(imageLinks)
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print("Failed to get image URLS from: \(urlString), error: \(error)")
            }
        }
    }
    
    func clearImageCache() {
        cache.removeAllObjects()
    }
}

//
//  NASAClient.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-22.
//

import Foundation

class NASAClient {
    static let shared = NASAClient()
    private let baseURL = "https://images-api.nasa.gov"
    
    private init() {}
    
    private func sendRequest(urlComponents: URLComponents, completed: @escaping (Result<Foundation.Data, NASAClientError>) -> ()) {
        guard let url = urlComponents.url else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
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
                } catch {
                    completed(.failure(.unableToParse))
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
}

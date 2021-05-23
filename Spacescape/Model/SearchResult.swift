//
//  SearchResult.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-22.
//

import Foundation

struct SearchResult: Codable {
    let collection: SearchCollection
}

struct SearchCollection: Codable {
    let items: [SearchItem]
}

struct SearchItem: Codable {
    let href: String
    let data: [SearchData]
    let links: [SearchLink]
}

struct SearchLink: Codable {
    let href: String
}

struct SearchData: Codable {
    let description: String
    let dateCreated: Date
    let title: String
}

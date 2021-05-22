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
    let links: [SearchLink]
    let data: [SearchData]
    let href: String
}

struct SearchLink: Codable {
    let href: String
}

struct SearchData: Codable {
    let title: String
    let description: String
    let dateCreated: Date
}

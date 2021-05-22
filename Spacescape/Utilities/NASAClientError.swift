//
//  NASAClientError.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-22.
//

import Foundation

enum NASAClientError: String, Error {
    case invalidURL = "This URL is invalid."
    case unableToCompleteRequest = "Unable to complete request."
    case invalidResponse = "Invalid response from the server."
    case invalidRequest = "Unacceptable request. A required parameter might be missing."
    case notFound = "The requested resource does not exist."
    case serverError = "Something went wrong on the API's end."
    case invalidData = "Invalid data from the server."
    case unableToParse = "Unable to parse the data from the server."
}

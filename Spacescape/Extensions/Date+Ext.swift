//
//  Date+Ext.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-22.
//

import Foundation

extension Date {
    func convertToDisplayFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}

//
//  Date+Ext.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-22.
//

import Foundation

extension Date {
    func convertToDisplayFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}

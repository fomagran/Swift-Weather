//
//  Extensions.swift
//  Swift Weather
//
//  Created by Fomagran on 2021/02/19.
//

import Foundation

extension Date {
    func shortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
}

//
//  ConvertDate.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 07.12.2022.
//
import Foundation

public extension Formatter {
    static let date = DateFormatter()
}

public extension Date {
    var rusFormatter : String {
        Formatter.date.calendar = Calendar(identifier: .iso8601)
        Formatter.date.locale   = Locale(identifier: "en_US_POSIX")
        Formatter.date.timeZone = .current
        Formatter.date.dateFormat = "dd.M.yyyy"
        return Formatter.date.string(from: self)
    }
}

public extension String {
    var getDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from: self) ?? Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from: components)
        
        return finalDate ?? Date()
    }
}

//
//  String+Extension.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 6.10.2025.
//

import Foundation
extension String {
    func formattedDateString() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy"
        
        guard let date = inputFormatter.date(from: self) else {
            return self // or return "N/A"
        }
        
        return outputFormatter.string(from: date)
    }
}

//
//  StringExtension.swift
//  UpcomingEvents
//
//  Created by Sean Bukich on 12/13/19.
//  Copyright © 2019 Sean Bukich. All rights reserved.
//

import Foundation

// Date Formats
enum DateStringFormats: String {
    case
    monthDayYearFormat = "MM.dd.yyyy",
    monthDayYearTimeFormat = "MMMM d, yyyy h:mm a"
}

extension String {
    
    // Format string and transform to a Date
    func getDateFormatFromString(string: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = string
        
        return dateFormatter.date(from: self)!
    }
    
    
    
}

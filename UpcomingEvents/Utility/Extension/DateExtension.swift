//
//  DateExtension.swift
//  UpcomingEvents
//
//  Created by Sean Bukich on 12/14/19.
//  Copyright © 2019 Sean Bukich. All rights reserved.
//

import Foundation

extension Date {
    
    func getDateKey() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateStringFormats.monthDayYearFormat.rawValue
        return formatter.string(from: self)

    }
    
}

//
//  Event.swift
//  UpcomingEvents
//
//  Created by Sean Bukich on 12/13/19.
//  Copyright © 2019 Sean Bukich. All rights reserved.
//

import Foundation

class Event: Codable {
    
    var title: String
    var start: String
    var end: String
    var conflicting: Bool?
    
    // Computed property to format start time
    var startTime: Date {
        get {
            return start.getDateFormatFromString(string: DateStringFormats.monthDayYearTimeFormat.rawValue)
        }
    }
    
    // Computed property to format
    var endTime: Date {
        get {
            return end.getDateFormatFromString(string: DateStringFormats.monthDayYearTimeFormat.rawValue)
        }
    }
    
    // Method to determind if two events overlap by comparing start/end times
    func conflicts(with event: Event) -> Bool {
        if self.startTime < event.endTime, self.endTime > event.startTime {
            return true
        }
        return false
    }
    
}

extension Event {
    
    enum JSONFields: String {
        case
        title = "title",
        start = "start",
        end = "end",
        conflicting = "conficting"
    }
    
    enum CodingKeys: String, CodingKey, Codable {
        case
        title = "title",
        start = "start",
        end = "end",
        conflicting = "conficting"
    }
    
}

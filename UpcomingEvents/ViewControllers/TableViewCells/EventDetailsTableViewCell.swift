//
//  EventDetailsTableViewCell.swift
//  UpcomingEvents
//
//  Created by Sean Bukich on 12/13/19.
//  Copyright © 2019 Sean Bukich. All rights reserved.
//

import UIKit

class EventDetailsTableViewCell: UITableViewCell {
    
    var cellData: Event?
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var conflictIndicator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        conflictIndicator.backgroundColor = .clear
    }
    
    func styleCell() {
        
        // Update UI with data from dataSource
        eventName.text = cellData?.title
        startTime.text = cellData?.start
        endTime.text = cellData?.end
        
        // Check to see if the cell needs to show as conflicting 
        if let cd = cellData, let _ = cd.conflicting {
            conflictIndicator.backgroundColor = .red
        }
        
    }

}

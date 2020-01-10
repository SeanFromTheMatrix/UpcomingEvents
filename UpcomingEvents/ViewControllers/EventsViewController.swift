//
//  EventsViewController.swift
//  UpcomingEvents
//
//  Created by Sean Bukich on 12/13/19.
//  Copyright © 2019 Sean Bukich. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // Store tableData into this dictionary:
    // The key is a date in string format
    // The value is an array of Events
    // Using dictionary for data soure allowed me to easily update UI when necessary (sorting data into sections and indicating conflicting events), without having to have use multiple data objects
    var sectionDataDictionary = [String: [Event]]()
    
    // Create empty string array
    var keyArray = [String]()
    
    // Create empty event array
    var eventArray = [Event]()
    
    // Create a variable that contains the URL for the mock.json file
    let fileData = Bundle.main.url(forResource: "mock", withExtension: "json")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Set tableView delegate and dataSource
        tableView.dataSource = self
        tableView.delegate = self
            
        // Hide tableView until data has loaded
        tableView.alpha = 0.0
        
        // Fetch table data
        UEAPI.fetchTableData(dataURL: fileData) { (_ events: [Event]) in
            
            // Sort table data
            self.sortTableData(events)
            
            // Make UI updates
            DispatchQueue.main.async {
                
                // Identify conflicting events
                self.identifyConflictingEvents(self.sectionDataDictionary)
                
                self.showConflictError()
                
                self.tableView.reloadData()
                
                // Show the tableView once data has loaded
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.alpha = 1.0
                })
            }
        }
        
    }
    
    // Show an alert that tells user about conflicting events
    func showConflictError() {
        
        let alert = UIAlertController(title: "Conflicting Events", message: "The red bar indicates that an event has a time conflict.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .default)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
     
    // Sort tableData
    func sortTableData(_ data: [Event]) {
        
        // Create a event object to manipulate from the data passed into method argument
        var events = data

        // Sort the events by Chronologically by startTime
        /// .startTime is a computed property on the Event model
        events.sort(by: { $0.startTime < $1.startTime })
        
        // Iterate through the events to create corresponding keys for the dictionary
        for item in events {
            
            // Create a string from the items startTime for dictionary key
            /// .getDateKey is a method on the DateExtension
            let key = item.startTime.getDateKey()
            
            // Check to see if there is a value for the key
            if self.sectionDataDictionary[key] == nil {
                // If there is no value, give the key an empty [Event]
                self.sectionDataDictionary[key] = self.eventArray
            }
            
            // Append the item to the dictionary at the correct key
            self.sectionDataDictionary[key]?.append(item)

        }
        
        // Set empty keyArray to the value of the dictionary keys as an array
        self.keyArray = Array(self.sectionDataDictionary.keys)

        // Sort the data in keyArray here and handle how it is displayed in UITableViewDelegate/DataSource
        self.keyArray.sort { ($0 < $1 ) }
        
    }
    
    // Identify conflicting events in the data source for the VC
    // Update 'conflicting' Boolean property on the Event class to indicate conflicing event times
    // Logic to determine if there is a conflict in the events: *** if eventA.startTime < eventB.endTime && eventA.endTime > eventB.startTime ***
    
    func identifyConflictingEvents(_ eventsDictionary: [String : [Event]]) { // Worst Case: n * (n-1) -> O(n^2)
        
        // Iterate through the dictionary (key, value) pairs
        // Instead of doing multiple nested loops, I could have potentially used .reduce or .filter to filter conflicting events. Would have been cleaner, but more complex and I would hav needed to create more data objects to work with. Also, a divide and conquer approach would be more efficient.
        
        for (_, events) in eventsDictionary { // n for n events
                             
            // Iterate through the events in the dictionary and remove the last index every iteration
            
            for index in events.indices.dropLast() { // best case scenario: n/2 times
                
                // Create a initial event to check on
                let baseEvent = events[index]

                // Get the comparing value's index and drop the first index of array. Increase index by 1
                
                for compIndex in events.indices.dropFirst(index + 1) { // worst case: n-1 times
                    
                    // Create variable for the event being compared to baseEvent
                    let compare = events[compIndex]
                    
                    // Compare the events using the .conflicts method on the Event class
                    if baseEvent.conflicts(with: compare) {
                        
                        // Update conflicting property on each Event object
                        baseEvent.conflicting = true
                        compare.conflicting = true
                    }
                }

            }
            
        }
        
    }
    
///    // devide and conq. for future improvements to the speed of algorithm  O(nlogn) time
///
///    func searchIdentifyConflictingEvents<T:Comparable> (array:[T], searchKey:T) -> Bool {
///
///        var leftIndex = 0
///        var rightIndex = array.count - 1
///
///        while leftIndex <= rightIndex {
///
///            let middleIndex = (leftIndex + rightIndex) / 2
///            let middleValue = array[middleIndex]
///
///            if middleValue == searchKey {
///                return true
///            }
///
///            if searchKey < middleValue {
///                rightIndex = middleIndex - 1
///            }
///
///            if searchKey > middleValue {
///                leftIndex = middleIndex + 1
///            }
///
///        }
///
///        return false
///    }

}

extension EventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Set title to be the string in the keyArray
        return keyArray[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    
}

extension EventsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionKey = keyArray[section]
        
        return sectionDataDictionary[sectionKey]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keyArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailsTableViewCell", for: indexPath) as! EventDetailsTableViewCell
        
        // Create variables to pass data to cells
        let sectionKey = keyArray[indexPath.section]
        let cellData = sectionDataDictionary[sectionKey]?[indexPath.row]
        
        // Pass data to cell
        cell.cellData = cellData
        
        // Make UI updates to cell
        cell.styleCell()
        
        return cell
    }
    
    
    
}

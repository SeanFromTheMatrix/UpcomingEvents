//
//  NetworkLayer.swift
//  UpcomingEvents
//
//  Created by Sean Bukich on 12/14/19.
//  Copyright © 2019 Sean Bukich. All rights reserved.
//

import Foundation

struct UEAPI {

    // Generic function to handle the API Calls / In this scenario: load from disk
    // Uses Codeable
    static func fetchTableData<T: Decodable>(dataURL: URL?, completion: @escaping (T) -> ()) {
        
        if let fd = dataURL {

            let data = try? Data(contentsOf: fd)
            do {
                guard let d = data else {
                    return
                }
                do {
                    let events = try JSONDecoder().decode(T.self, from: d)

                    completion(events)

                } catch {
                    print("error")
                }

            }
        }
        
        
    }

}

//
//  StudentLocationCollection.swift
//  OnTheMap
//
//  Created by Shirley on 2/5/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

// MARK: - StudentLocationCollection

class StudentLocationCollection {
    
    // MARK: Properties
    
    var locations: [StudentInformation]?
    
    // MARK: Initializers
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> StudentLocationCollection {
        
        struct Singleton {
            static var sharedInstance = StudentLocationCollection()
        }
        return Singleton.sharedInstance
    }
    
    // Build a collection of StudentInformation from dictionary collection
    
    class func locationsFromResults(_ results: [[String:AnyObject]]) -> Void {
        
        var loc = [StudentInformation]()
        
        // iterate through array of dictionaries, each location is a dictionary
        for result in results {
            loc.append(StudentInformation(dictionary: result))
        }
        
        self.sharedInstance().locations = loc
    }
}


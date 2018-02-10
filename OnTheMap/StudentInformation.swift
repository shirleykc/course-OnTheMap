//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Shirley on 1/2/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

// MARK: - StudentInformation

struct StudentInformation {
    
    // MARK: Properties
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    
    
    // MARK: Initializers
    
    // Construct a StudentInformation from a dictionary
    
    init(dictionary: [String:AnyObject]) {
        objectId = dictionary[UdacityClient.JSONResponseKeys.ObjectId] as? String
        uniqueKey = dictionary[UdacityClient.JSONResponseKeys.UniqueKey] as? String
        firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as? String
        mapString = dictionary[UdacityClient.JSONResponseKeys.MapString] as? String
        mediaURL = dictionary[UdacityClient.JSONResponseKeys.MediaURL] as? String
        latitude = dictionary[UdacityClient.JSONResponseKeys.Latitude] as? Double
        longitude = dictionary[UdacityClient.JSONResponseKeys.Longitude] as? Double
    }
}

// MARK: - StudentInformation: Equatable

extension StudentInformation: Equatable {

    static func ==(lhs: StudentInformation, rhs: StudentInformation) -> Bool {
        return lhs.objectId == rhs.objectId
    }
}


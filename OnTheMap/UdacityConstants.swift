//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Shirley on 12/31/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

// MARK: - UdacityClient (Constants)

import UIKit

extension UdacityClient {
    
    // MARK: Constants
    
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        
        // MARK: Udacity Parse API
        static let ParseApiHost = "parse.udacity.com"
        static let ParseApiPath = "/parse/classes"
        
        // MARK: Udacity API
        static let UdacityApiHost = "www.udacity.com"
        static let UdacityApiPath = "/api"
        
        // MARK: Udacity Sign Up URL
        static let UdacitySignUpURL = "https://www.udacity.com/account/auth#!/signup"
    }
    
    // MARK: Methods
    
    struct Methods {
        
        // MARK: StudentLocation
        static let StudentLocation = "/StudentLocation"
       
        // MARK: Authentication
        static let AuthenticationSession = "/session"
        
        // MARK: Users
        static let UserIDPublicData = "/users/{id}"
    }
    
    // MARK: HTTP Methods
    
    struct HTTPMethods {
        static let HttpPost = "POST"
        static let HttpDelete = "DELETE"
    }
    
    // MARK: HTTP Header Keys
    
    struct HTTPHeaderKeys {
        
        // MARK: Udacity Parse API header keys
        static let ParseApplicationId = "X-Parse-Application-Id"
        static let ParseRESTAPIKey = "X-Parse-REST-API-Key"
        
        // MARK: General
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        
        // MARK: Cookies
        static let XsrfToken = "X-XSRF-TOKEN"
    }
    
    // MARK: HTTP Header Values
    
    struct HTTPHeaderValues {
        static let ParseApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ParseApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApplicationJson = "application/json"
    }
    
    // MARK: Cookies
    
    struct CookieNames {
        static let XsrfCookieName = "XSRF-TOKEN"
    }
    
    // MARK: URL Keys
    
    struct URLKeys {
        static let UserID = "id"
    }

    // MARK: Parameter Keys
    
    struct ParameterKeys {
        
        // MARK: Parameter keys for GET StudentLocation
        static let Limit = "limit"
        static let Order = "order"
    }
    
    // MARK: Parameter Values
    
    struct ParameterValues {
        
        // MARK: Parameter values for GET StudentLocation
        static let ResultLimit = "100"
        static let OrderByUpdatedAtDesc = "-updatedAt"
    }
    
    // MARK: JSON Body Keys
    
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let Account = "account"
        static let AccountRegistered = "regisered"
        static let AccountKey = "key"
        static let Session = "session"
        static let SessionID = "id"
        static let SessionExpiration = "expiration"
        
        // MARK: StudentLocation
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let Results = "results"
        
        // MARK: Users
        static let User = "user"
        static let UserKey = "key"
        static let UserFirstName = "first_name"
        static let UserLastName = "last_name"
    }
    
    // MARK: UI
    
    struct UI {
        static let LoginColorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).cgColor
        static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
        static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    }
}

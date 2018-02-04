//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Shirley on 1/1/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    // MARK: Login - Authentication (GET) Methods
    /*
     Steps for Authentication...
     https://www.udacity.com/api/session
     
     Step 1: Create a session ID and a user ID
     Step 2: Get user data
     */
    
    func authenticateWithLogin(_ loginParameters: [String:String], completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        self.getSessionAndUserID(loginParameters) { (success, sessionID, userID, errorString) in
            
            if success {
                
                // success! we have the sessionID and userID!
                self.sessionID = sessionID
                self.userID = userID
                
                // get user data
                self.getUserPublicData() { (success, user, error) in
                    if success {
                        if let user = user {
                            var parameters = [String:AnyObject]()
                            parameters[UdacityClient.JSONResponseKeys.UniqueKey] = user[UdacityClient.JSONResponseKeys.AccountKey]
                            parameters[UdacityClient.JSONResponseKeys.FirstName] = user[UdacityClient.JSONResponseKeys.UserFirstName]
                            parameters[UdacityClient.JSONResponseKeys.LastName] = user[UdacityClient.JSONResponseKeys.UserLastName]
                            self.student = StudentInformation(dictionary: parameters)
                        }
                        completionHandlerForAuth(success, errorString)
                    } else {
                        completionHandlerForAuth(success, errorString)
                    }
                }
                completionHandlerForAuth(success, errorString)
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
    }
    
    // MARK: Logout Session - Authentication (DELETE) Methods
    /*
     Steps for Authentication Logout ...
     https://www.udacity.com/api/session
     
     Step 1: Delete a session
     */
    
    func logoutSession(completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        self.deleteSession() { (success, errorString) in
            if success {
                completionHandlerForAuth(success, errorString)
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
    }
    
    // MARK: Parse GET Student Locations
    
    func getStudentLocations(_ completionHandlerForLocationlist: @escaping (_ result: [StudentInformation]?, _ error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let getMethod: String = UdacityClient.Methods.StudentLocation
      
        /* 2. Make the request */
        let _ = taskForParseGETMethod(getMethod) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLocationlist(nil, error)
            } else {
                
                if let results = results?[UdacityClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    
                    let locations = StudentInformation.locationsFromResults(results)
                    completionHandlerForLocationlist(locations, nil)
                } else {
                    completionHandlerForLocationlist(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    
    // MARK: Udacity GET User Data
    
    func getUserPublicData(_ completionHandlerForUserData: @escaping (_ success: Bool, _ result: [String:AnyObject]?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var mutableMethod: String = UdacityClient.Methods.UserIDPublicData
        mutableMethod = substituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: String(UdacityClient.sharedInstance().userID!))!
        
        /* 2. Make the request */
        let _ = taskForUdacityGETMethod(mutableMethod) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForUserData(false, nil, (error.userInfo[NSLocalizedDescriptionKey] as! String))
            } else {
                if let user = results?[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] {
                    completionHandlerForUserData(true, user, nil)
                } else {
                    completionHandlerForUserData(false, nil, "Could not parse getUserPublicData")
                }
            }
        }
    }
    
    // MARK: Parse POST StudentLocation
    
    func postStudentLocation(_ studentParameters: [String:Any], _ completionHandlerForUserData: @escaping (_ success: Bool, _ result: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let postMethod: String = UdacityClient.Methods.StudentLocation
        let jsonBody = parseHTTPBodyFromUserData(studentParameters)
        
        /* 2. Make the request */
        let _ = taskForParsePOSTMethod(postMethod, jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForUserData(false, nil, (error.userInfo[NSLocalizedDescriptionKey] as! String))
            } else {
                if let objectId = results?[UdacityClient.JSONResponseKeys.ObjectId] as? String {
                    completionHandlerForUserData(true, objectId, nil)
                } else {
                    completionHandlerForUserData(false, nil, "Could not parse postStudentLocation")
                }
            }
        }
    }
    
    // Call Udacity POST to get session ID and user ID
    
    private func getSessionAndUserID(_ loginParameters: [String:String], completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ userID: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let postMethod: String = UdacityClient.Methods.AuthenticationSession
        let jsonBody = udacityHTTPBodyFromLoginParameters(loginParameters)
        
        /* 2. Make the request */
        let _ = taskForUdacityPOSTMethod(postMethod, jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForSession(false, nil, nil, (error.userInfo[NSLocalizedDescriptionKey] as! String))
            } else {
                if let session = results?[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject],
                    let account = results?[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject] {
                    if let sessionID = session[UdacityClient.JSONResponseKeys.SessionID] as? String,
                        let userID = account[UdacityClient.JSONResponseKeys.AccountKey] as? String {
                        completionHandlerForSession(true, sessionID, userID, nil)
                    } else {
                        completionHandlerForSession(false, nil, nil, "Login Failed (Session or User ID).")
                    }
                } else {
                    completionHandlerForSession(false, nil, nil, "Login Failed (Session).")
                }
            }
        }
    }
    
    // Call Udacity DELETE to delete a session
    
    private func deleteSession(completionHandlerForSession: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let deleteMethod: String = UdacityClient.Methods.AuthenticationSession
       
        /* 2. Make the request */
        let _ = taskForUdacityDELETEMethod(deleteMethod) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForSession(false, (error.userInfo[NSLocalizedDescriptionKey] as! String))
            } else {
                if let session = results?[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject] {
                    if (session[UdacityClient.JSONResponseKeys.SessionID] as? String) != nil {
                        completionHandlerForSession(true, nil)
                    } else {
                         completionHandlerForSession(false, "Logout Failed (Delete Session).")
                    }
                } else {
                      completionHandlerForSession(false, "Logout Failed (Delete Session).")
                }
            }
        }
    }
    
    // Create the Udacity HTTPBody string from parameters
    
    private func udacityHTTPBodyFromLoginParameters(_ parameters: [String:String]) -> String {
        
        var httpBody = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\": {"
        
        var parameterCount = 0
        for (key, value) in parameters {
            if parameterCount > 0 {
                httpBody.append(",")
            }
            httpBody = "\(httpBody)\"\(key)\": \"\(value)\""
            parameterCount += 1
        }
        httpBody.append("}}")
        
        return httpBody
    }
    
    // Create the Parse HTTPBody string from parameters
    
    private func parseHTTPBodyFromUserData(_ parameters: [String:Any]) -> String {
        
        var httpBody = "{"
        
        var parameterCount = 0
        for (key, value) in parameters {
            if parameterCount > 0 {
                httpBody.append(",")
            }
            if value is String {
                httpBody = "\(httpBody)\"\(key)\": \"\(value)\""
            } else {
                httpBody = "\(httpBody)\"\(key)\": \(value)"
            }
            parameterCount += 1
        }
        httpBody.append("}")
        
        return httpBody
    }
}

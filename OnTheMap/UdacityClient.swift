//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Shirley on 12/31/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

// MARK: - UdacityClient: NSObject

class UdacityClient : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
       
    // authentication state
    var sessionID: String? = nil
    var userID: String? = nil
    var student: StudentInformation? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Udacity POST Method
    
    func taskForUdacityPOSTMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        
        let request = NSMutableURLRequest(url: udacityURL(withPathExtension: method))
        request.httpMethod = UdacityClient.HTTPMethods.HttpPost
        request.addValue(UdacityClient.HTTPHeaderValues.ApplicationJson, forHTTPHeaderField: UdacityClient.HTTPHeaderKeys.Accept)
        request.addValue(UdacityClient.HTTPHeaderValues.ApplicationJson, forHTTPHeaderField: UdacityClient.HTTPHeaderKeys.ContentType)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForUdacityPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                if let desc = error?.localizedDescription {
                    sendError(desc)
                } else {
                    sendError("There was an error with your request: \(error!)")
                }
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            let respCode = (response as? HTTPURLResponse)?.statusCode
            guard let statusCode = respCode, statusCode >= 200 && statusCode <= 299 else {
                if (respCode == 403) {
                    sendError("Email and password do not match, please try again.")
                } else {
                    sendError("Your request returned a status code \(respCode!) other than 2xx!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            
            self.convertUdacityDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        
        task.resume()
        
        return task
    }
    
    // MARK: Udacity DELETE Method
    
    func taskForUdacityDELETEMethod(_ method: String, completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */

        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == UdacityClient.CookieNames.XsrfCookieName {
                xsrfCookie = cookie
            }
        }

        /* 2/3. Build the URL, Configure the request */

        let request = NSMutableURLRequest(url: udacityURL(withPathExtension: method))
        request.httpMethod = UdacityClient.HTTPMethods.HttpDelete

        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: UdacityClient.HTTPHeaderKeys.XsrfToken)
        }
        
        /* 4. Make the request */
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForUdacityDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                if let desc = error?.localizedDescription {
                    sendError(desc)
                } else {
                    sendError("There was an error with your request: \(error!)")
                }
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            let respCode = (response as? HTTPURLResponse)?.statusCode
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code \(respCode!) other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            
            self.convertUdacityDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        
        /* 7. Start the request */
        
        task.resume()
        
        return task
    }
    
    // MARK: Udacity GET Method
    
    func taskForUdacityGETMethod(_ method: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */        

        /* 2/3. Build the URL, Configure the request */
        
        let request = NSMutableURLRequest(url: udacityURL(withPathExtension: method))
        
        /* 4. Make the request */
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForUdacityGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                if let desc = error?.localizedDescription {
                    sendError(desc)
                } else {
                    sendError("There was an error with your request: \(error!)")
                }
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            let respCode = (response as? HTTPURLResponse)?.statusCode
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code \(respCode!) other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            
            self.convertUdacityDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Parse GET Method
    
    func taskForParseGETMethod(_ method: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        let parameters = [UdacityClient.ParameterKeys.Limit: UdacityClient.ParameterValues.ResultLimit,
                          UdacityClient.ParameterKeys.Order: UdacityClient.ParameterValues.OrderByUpdatedAtDesc
        ]
        
        /* 2/3. Build the URL, Configure the request */
        
        let request = NSMutableURLRequest(url: parseURLFromParameters(parameters as [String:AnyObject], withPathExtension: method))
        request.addValue(UdacityClient.HTTPHeaderValues.ParseApplicationId, forHTTPHeaderField: UdacityClient.HTTPHeaderKeys.ParseApplicationId)
        request.addValue(UdacityClient.HTTPHeaderValues.ParseApiKey, forHTTPHeaderField: UdacityClient.HTTPHeaderKeys.ParseRESTAPIKey)
        
        /* 4. Make the request */
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForParseGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                if let desc = error?.localizedDescription {
                    sendError(desc)
                } else {
                    sendError("There was an error with your request: \(error!)")
                }
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            let respCode = (response as? HTTPURLResponse)?.statusCode
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code \(respCode!) other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            
            self.convertParseDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        
        task.resume()
        
        return task
    }
 
    // MARK: Parse POST Method
    
    func taskForParsePOSTMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2/3. Build the URL, Configure the request */
        
        let request = NSMutableURLRequest(url: parseURLFromParameters([:], withPathExtension: method))
        request.httpMethod = UdacityClient.HTTPMethods.HttpPost
        request.addValue(UdacityClient.HTTPHeaderValues.ParseApplicationId, forHTTPHeaderField: UdacityClient.HTTPHeaderKeys.ParseApplicationId)
        request.addValue(UdacityClient.HTTPHeaderValues.ParseApiKey, forHTTPHeaderField: UdacityClient.HTTPHeaderKeys.ParseRESTAPIKey)
        request.addValue(UdacityClient.HTTPHeaderValues.ApplicationJson, forHTTPHeaderField: UdacityClient.HTTPHeaderKeys.Accept)
        request.addValue(UdacityClient.HTTPHeaderValues.ApplicationJson, forHTTPHeaderField: UdacityClient.HTTPHeaderKeys.ContentType)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
         
        /* 4. Make the request */
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForUdacityPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                if let desc = error?.localizedDescription {
                    sendError(desc)
                } else {
                    sendError("There was an error with your request: \(error!)")
                }
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            let respCode = (response as? HTTPURLResponse)?.statusCode
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code \(respCode!) other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            
            self.convertParseDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given raw Udacity JSON, return a usable Foundation object
    
    private func convertUdacityDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range) /* subset response data! */
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(newData)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // given raw Parse JSON, return a usable Foundation object
    
    private func convertParseDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a Udacity URL
    
    private func udacityURL(withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.UdacityApiHost
        components.path = UdacityClient.Constants.UdacityApiPath + (withPathExtension ?? "")
        
        return components.url!
    }
    
    // create a Parse URL from parameters
    
    private func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ParseApiHost
        components.path = UdacityClient.Constants.ParseApiPath + (withPathExtension ?? "")
        
        if parameters.count > 0 {
            components.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}

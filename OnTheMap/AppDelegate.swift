//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Shirley on 12/31/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

// MARK: - AppDelegate: UIResponder, UIApplicationDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties

    var window: UIWindow?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}

// MARK: Helper methods

extension AppDelegate {
    
    // MARK: Configure background gradient
    
    func configureBackgroundGradient(_ view: UIView) {
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [UdacityClient.UI.GreyColor, UdacityClient.UI.GreyColor]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }
    
    // MARK: Configure TextField
    
    func configureTextField(_ textField: UITextField) {
        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .always
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor.black
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UdacityClient.UI.GreyColor])
        textField.tintColor = UdacityClient.UI.BlueColor
        textField.borderStyle = .bezel
    }
    
    func validateURLString(_ urlString: String?, completionHandlerForURL: @escaping (_ success: Bool, _ url: URL?, _ errorString: String?) -> Void) {
        
        if let mediaURL = URL(string: urlString!) {
            completionHandlerForURL(true, mediaURL, nil)
            return
        } else {
            completionHandlerForURL(false, nil, "Invalid URL string \(urlString!)")
            return
        }
    }

    func presentAlert(_ controller: UIViewController, _ errorString: String?) {
        if let errorString = errorString {
            let alert = UIAlertController(title: "Alert", message: errorString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"Dismiss\" alert occured.")
            }))
            controller.present(alert, animated: true, completion: nil)
        }
    }
}

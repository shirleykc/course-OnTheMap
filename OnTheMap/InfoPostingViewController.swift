//
//  InfoPostingViewController.swift
//  OnTheMap
//
//  Created by Shirley on 1/10/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - InfoPostingViewController: UIViewController

/**
 * This view controller presents the info posting view
 * to allow users to specify their own locations and links.
 */

class InfoPostingViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var session: URLSession!
    
    lazy var geocoder = CLGeocoder()
    
    // MARK: Outlets
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaURLTextField: UITextField!
    @IBOutlet weak var findLocationButton: BorderedButton!
    @IBOutlet weak var alertTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        navigationItem.title = "Add Location"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancelAdd))
        
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationTextField.text = ""
        mediaURLTextField.text = ""
        alertTextLabel.text = ""
        setUIEnabled(true)
    }
    
    // MARK: Cancel Add Location
    
    @objc func cancelAdd() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Find location
    
    @IBAction func findLocationPressed(_ sender: AnyObject) {
        
        if locationTextField.text!.isEmpty || mediaURLTextField.text!.isEmpty {
            alertTextLabel.text = "Location or Media URL Empty."
        } else {
            // Update View
            setUIEnabled(false)
            
            // Geocode Address String
            if let address = locationTextField.text {
                activityIndicatorView.startAnimating()
                forwardGeocodingWithAddress(address) { (success, place, errorString) in
                    performUIUpdatesOnMain {
                        self.activityIndicatorView.stopAnimating()
                        if success {
                            self.completeForwardGeocoding(place!)
                        } else {
                            self.displayError(errorString)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Forward geocoding with address string
    
    func forwardGeocodingWithAddress(_ address: String, completionHandlerForGeocode: @escaping (_ success: Bool, _ place: CLPlacemark?, _ errorString: String?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        self.geocoder.geocodeAddressString(address) { (placemarks, error) in
 
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print(error!)
                completionHandlerForGeocode(false, nil, "Unable to forward geocode address")
                return
            }
            
            /* GUARD: No location found */
            guard let placemarks = placemarks,
                placemarks.count > 0 else {
                completionHandlerForGeocode(false, nil, "No location found")
                return
            }
            
            /* GUARD: Unable to find first location */
            guard let place = placemarks.first else {
                completionHandlerForGeocode(false, nil, "Unable to find first location")
                return
            }
            
            completionHandlerForGeocode(true, place, nil)
        }
    }
    
    // MARK: Complete forward geocoding
    
    private func completeForwardGeocoding(_ place: CLPlacemark) {
        setUIEnabled(true)

        // go to next view
        let controller = storyboard!.instantiateViewController(withIdentifier: "ForwardGeocodingViewController") as! ForwardGeocodingViewController
        controller.place = place
        controller.mediaURL = mediaURLTextField.text!
        navigationController!.pushViewController(controller, animated: true)
    }
}

// MARK: - InfoPostingViewController: UITextFieldDelegate

extension InfoPostingViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - InfoPostingViewController (Configure UI)

extension InfoPostingViewController {
    
    // MARK: Enable or disable UI
    
    func setUIEnabled(_ enabled: Bool) {
        locationTextField.isEnabled = enabled
        mediaURLTextField.isEnabled = enabled
        findLocationButton.isEnabled = enabled
        alertTextLabel.text = ""
        alertTextLabel.isEnabled = enabled
        
        // adjust find location button alpha
        if enabled {
            findLocationButton.alpha = 1.0
        } else {
            findLocationButton.alpha = 0.5
        }
    }
    
    // MARK: Display error
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            setUIEnabled(true)
            alertTextLabel.text = errorString
            alertTextLabel.textColor = UIColor.red
        }
    }
    
    // MARK: Configure UI
    
    func configureUI() {
        appDelegate.configureBackgroundGradient(view)
        configureTextField(locationTextField)
        configureTextField(mediaURLTextField)
        activityIndicatorView.stopAnimating()
    }
    
    // MARK: Configure text field
    
    func configureTextField(_ textField: UITextField) {
        appDelegate.configureTextField(textField)
        textField.delegate = self
    }
}

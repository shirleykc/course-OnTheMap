//
//  ForwardGeocodingViewController.swift
//  OnTheMap
//
//  Created by Shirley on 1/14/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import MapKit

// MARK: - ForwardGeocodingViewController: UIViewController

/**
 * This view controller demonstrates the objects involved in displaying forwarded geocode
 * on a map.
 *
 * The map is a MKMapView.
 * The pins are represented by MKPointAnnotation instances.
 *
 * The view controller conforms to the MKMapViewDelegate so that it can receive a method
 * invocation when a pin annotation is tapped. It accomplishes this using two delegate
 * methods: one to put a small "info" button on the right side of each pin, and one to
 * respond when the "info" button is tapped.
 */

class ForwardGeocodingViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!

    var student: StudentInformation?
    var place: CLPlacemark?
    var mediaURL: String?
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: BorderedButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        /* Grab the student info */
        student = UdacityClient.sharedInstance().student
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
        
        mapView.delegate = self
        
        navigationItem.title = "Add Location"
        navigationItem.backBarButtonItem?.title = "Add Location"
        
        if let placeName = place?.name,
            let placeState = place?.administrativeArea,
            let placeCountry = place?.country,
            let placeLocation = place?.location {
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = placeLocation.coordinate
            annotation.title = "\(placeName), \(placeState), \(placeCountry)"
            
            mapView.addAnnotation(annotation)
            
            // center the map on the latest student location
            centerMapOnStudentLocation(location: placeLocation)
            
            student?.latitude = annotation.coordinate.latitude
            student?.longitude = annotation.coordinate.longitude
            student?.mapString = annotation.title
            student?.mediaURL = mediaURL!
        } else {
            print("Unable to create annotation: \(place!)")
            appDelegate.presentAlert(self, "Unable to create annotation")
            return
        }
    }

    // MARK: Finish - post student location using Parse API
    
    @IBAction func finishPressed(_ sender: AnyObject) {
        
        setUIEnabled(false)
        
        let studentParameters = buildJsonBodyParameters(student!)
        activityIndicatorView.startAnimating()
        UdacityClient.sharedInstance().postStudentLocation(studentParameters) { (success, results, errorString) in
            performUIUpdatesOnMain {
                self.activityIndicatorView.stopAnimating()
                if success {
                    self.completeInfoPosting()
                } else {
                    print(errorString!)
                    self.appDelegate.presentAlert(self, "Unable to post student location, please try again")
                }
            }
        }
    }
    
    // MARK: JSON body parameters with student information
    
    private func buildJsonBodyParameters(_ student: StudentInformation) -> [String:Any] {

        /* TASK: Login, then get a session id */

        /* 1. Set the jsonbody parameters */
        let jsonBodyParameters = [
            UdacityClient.JSONResponseKeys.UniqueKey: student.uniqueKey!,
            UdacityClient.JSONResponseKeys.FirstName: student.firstName!,
            UdacityClient.JSONResponseKeys.LastName: student.lastName!,
            UdacityClient.JSONResponseKeys.MapString: student.mapString!,
            UdacityClient.JSONResponseKeys.MediaURL: student.mediaURL!,
            UdacityClient.JSONResponseKeys.Latitude: student.latitude!,
            UdacityClient.JSONResponseKeys.Longitude: student.longitude!
            ] as [String : Any]

        return jsonBodyParameters
    }
    
    // MARK: Center map on latest student location
    
    private func centerMapOnStudentLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000  // meters
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: Complete info posting
    
    private func completeInfoPosting() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: MKMapViewDelegate

extension ForwardGeocodingViewController: MKMapViewDelegate {
    
    // MARK: mapView - Create a view with a right callout accessory view
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // MARK: mapView - opens the system browser to the URL specified in
    // the annotationViews subtitle property.
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                appDelegate.validateURLString(toOpen) { (success, url, errorString) in
                    performUIUpdatesOnMain {
                        if success {
                            UIApplication.shared.open(url!, options: [:]) { (success) in
                                if !success {
                                    self.appDelegate.presentAlert(self, "Cannot open URL \(url!)")
                                }
                            }
                        } else {
                            self.appDelegate.presentAlert(self, errorString)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - ForwardGeocodingViewController (Configure UI)

extension ForwardGeocodingViewController {
    
    // MARK: Enable or disable UI
    
    func setUIEnabled(_ enabled: Bool) {
        finishButton.isEnabled = enabled
        
        // adjust finish button alpha
        if enabled {
            finishButton.alpha = 1.0
        } else {
            finishButton.alpha = 0.5
        }
    }
    
    // MARK: Configure UI
    
    func configureUI() {
        activityIndicatorView.stopAnimating()
        setUIEnabled(true)
    }
}

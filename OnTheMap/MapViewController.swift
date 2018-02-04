//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Shirley on 1/7/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
import MapKit

// MARK: - MapViewController: UIViewController, MKMapViewDelegate

/**
 * This view controller demonstrates the objects involved in displaying pins on a map.
 *
 * The map is a MKMapView.
 * The pins are represented by MKPointAnnotation instances.
 *
 * The view controller conforms to the MKMapViewDelegate so that it can receive a method
 * invocation when a pin annotation is tapped. It accomplishes this using two delegate
 * methods: one to put a small "info" button on the right side of each pin, and one to
 * respond when the "info" button is tapped.
 */

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var completionHandlerForOpenURL: ((_ success: Bool) -> Void)?

    var locations: [StudentInformation] = [StudentInformation]()
    var annotations: [MKPointAnnotation] = [MKPointAnnotation]()

    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
 
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mapView.delegate = self
        
        // get student locations
        
        activityIndicatorView.startAnimating()
        UdacityClient.sharedInstance().getStudentLocations { (locations, error) in
            performUIUpdatesOnMain {
                self.activityIndicatorView.stopAnimating()
                if let locations = locations {
                    self.locations = locations
                    self.createAnnotations()
                    
                    // center the map on the latest student location
                    if let latestLoc = self.locations.first {
                        self.centerMapOnStudentLocation(location: latestLoc)
                    }
                } else {
                    print(error ?? "empty error")
                    self.appDelegate.presentAlert(self, "Cannot load student locations, please try again")
                }
            }
        }
    }
    
    func centerMapOnStudentLocation(location: StudentInformation) {
        let initialLocation = CLLocation(latitude: location.latitude!, longitude: location.longitude!)
        let regionRadius: CLLocationDistance = 1000000  // meters
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func createAnnotations() {
        
        // Create an MKPointAnnotation for each dictionary in locations.
        
        for student in locations {
            
            if let latitude = student.latitude,
                let longitude = student.longitude {
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                var firstName = student.firstName
                if firstName == nil {
                    firstName = ""
                }
                var lastName = student.lastName
                if lastName == nil {
                    lastName = ""
                }
                
                var mediaURL = student.mediaURL
                if mediaURL == nil {
                    mediaURL = ""
                }
                
                // create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(firstName!) \(lastName!)"
                annotation.subtitle = mediaURL
                
                // place the annotation in an array of annotations.
                annotations.append(annotation)
            }
        }
        
        // add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: - MKMapViewDelegate
    
    // MARK: mapView - viewFor - Create a view with right callout accessory view
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
    
    // MARK: mapView - calloutAccessoryControlTapped - opens the system browser
    // to the URL specified in the annotationViews subtitle property.
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

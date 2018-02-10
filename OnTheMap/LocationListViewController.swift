//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Shirley on 1/2/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

// MARK: - LocationListViewController: UIViewController

/**
 * This view controller presents a table view of student locations.
 */

class LocationListViewController: UIViewController {
    
    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var studentLocations: StudentLocationCollection!
    
    // MARK: Outlets
    
    @IBOutlet weak var locationsTableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        /* Grab the student locations */
        studentLocations = StudentLocationCollection.sharedInstance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicatorView.startAnimating()
        UdacityClient.sharedInstance().getStudentLocations { (locations, error) in
            performUIUpdatesOnMain {
                self.activityIndicatorView.stopAnimating()
                if let locs = locations {
                    self.studentLocations.locations = locs
                    self.locationsTableView.reloadData()
                } else {
                    print(error ?? "empty error")
                    self.appDelegate.presentAlert(self, "Cannot load student locations, please try again")
                }
            }
        }
    }   
}

// MARK: - LocationListViewController: UITableViewDelegate, UITableViewDataSource

extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: tableView - cellForRowAt
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentLocationTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! StudentLocationTableCell

        if let locations = studentLocations.locations {
            let location = locations[(indexPath as NSIndexPath).row]
            
            /* Set cell defaults */
            var firstName = location.firstName
            if firstName == nil {
                firstName = ""
            }
            var lastName = location.lastName
            if lastName == nil {
                lastName = ""
            }
            cell.studentNameLabel?.text = "\(firstName!) \(lastName!)"
            
            var mediaURL = location.mediaURL
            if mediaURL == nil {
                mediaURL = ""
            }
            cell.mediaURLLabel?.text = "\(mediaURL!)"
        }
            
        return cell
    }
    
    // MARK: tableView - numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locations = studentLocations.locations {
            return locations.count
        } else {
            return 0
        }
    }
    
    // MARK: tableView - didSelectRowAt
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let locations = studentLocations.locations else {
            appDelegate.presentAlert(self, "No student locations available")
            return
        }
        
        let studentInformation = locations[(indexPath as NSIndexPath).row]

        // deselect the selected row
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let mediaURLString = studentInformation.mediaURL else {
            appDelegate.presentAlert(self, "Invalid URL")
            return
        }
        
        appDelegate.validateURLString(mediaURLString) { (success, url, errorString) in
            performUIUpdatesOnMain {
                if success {
                    UIApplication.shared.open(url!, options: [:]) { (success) in
                        if !success {
                            self.appDelegate.presentAlert(self, "Cannot open URL")
                        }
                    }
                } else {
                    self.appDelegate.presentAlert(self, errorString)
                }
            }
        }
    }
    
    // MARK: tableView - heightForRowAt
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

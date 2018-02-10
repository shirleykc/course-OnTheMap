//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Shirley on 12/31/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

/**
 * This view controller presents a Udacity login page.
 * It allows user to login with Udacity credential or sign-up Udacity.
 */

class LoginViewController: UIViewController {

    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var session: URLSession!
    
    // MARK: Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var alertTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Grab the app delegate */
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        configureUI()
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        usernameTextField.text = ""
        passwordTextField.text = ""
        alertTextLabel.text = ""
        setUIEnabled(true)
        activityIndicatorView.stopAnimating()
    }
    
    // MARK: Login
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            alertTextLabel.text = "Email Address or Password Empty."
        } else {
            setUIEnabled(false)
            activityIndicatorView.startAnimating()

            /*
             Steps for Authentication...
             https://www.udacity.com/api/session
             
             Step 1: Create a session ID
             
             Extra Steps...
             Step 4: Get the user id
             Step 5: Go to the next view!
             */
            let loginParameters = getLoginCredential()
            UdacityClient.sharedInstance().authenticateWithLogin(loginParameters) { (success, errorString) in
                performUIUpdatesOnMain {
                    self.activityIndicatorView.stopAnimating()
                    if success {
                        self.completeLogin()
                    } else {
                        print(errorString!)
                        self.displayError(errorString!)
                    }
                }
            }
        }
    }
    
    // MARK: Sign Up Udacity
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        /*
         Steps for Authentication...
         https://www.udacity.com/account/auth#!/signup
         
         Step 1: Sign Up via the website
         */
        
        if let signUpURL = URL(string: UdacityClient.Constants.UdacitySignUpURL) {
            performUIUpdatesOnMain {
                UIApplication.shared.open(signUpURL, options: [:]) { (success) in
                     if success {
                        self.completeSignUp()
                    } else {
                        self.displayError("Cannot open SignUp URL, please try again")
                    }
                }
            }
        } else {
            self.displayError("Invalid SignUp URL")
        }
    }
    
    // MARK: JSON body parameters with login credential
    
    func getLoginCredential() -> [String:String] {
        
        /* TASK: Login, then get a session id */
        
        /* 1. Set the jsonbody parameters */
        let jsonBodyParameters = [
            UdacityClient.JSONBodyKeys.Username: usernameTextField.text!,
            UdacityClient.JSONBodyKeys.Password: passwordTextField.text!
        ]
        
        return jsonBodyParameters
    }
    
    // Complete login - go to next view
    
    func completeLogin() {
        alertTextLabel.text = ""
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    // Complete sign up
    
    func completeSignUp() {
        alertTextLabel.text = ""
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - LoginViewController (Configure UI)

extension LoginViewController {
    
    // MARK: Enable or disable UI
    
    func setUIEnabled(_ enabled: Bool) {
        
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        alertTextLabel.text = ""
        alertTextLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
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
    
    // MARK: Configur UI
    
    func configureUI() {

        appDelegate.configureBackgroundGradient(view)       
        configureTextField(usernameTextField)
        configureTextField(passwordTextField)
        activityIndicatorView.stopAnimating()
    }
    
    // MARK: Configure Text Field
    
    func configureTextField(_ textField: UITextField) {
        appDelegate.configureTextField(textField)
        textField.delegate = self
    }
}

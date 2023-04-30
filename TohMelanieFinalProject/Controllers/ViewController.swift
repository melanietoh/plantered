//
//  ViewController.swift
//  TohMelanieFinalProject
//
//  Created by Mel on 4/12/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var messageLabel: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Rounding button
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
    }

    // Background touched -> Dismiss keyboard
    @IBAction func backgroundPressed(_ sender: UIButton) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    // Move keyboard to password field
    @IBAction func nextPressed(_ sender: UITextField) {
        passwordField.becomeFirstResponder()
    }
    
    // Dismiss keyboard
    @IBAction func donePressed(_ sender: UITextField) {
        passwordField.resignFirstResponder()
    }
    
    // Login and sign up
    @IBAction func login(_ sender: UIButton) {
        // Empty field(s)
        guard let username = usernameField.text,
              let password = passwordField.text
        else {
            usernameField.text = ""
            passwordField.text = ""
            
            let alertController = UIAlertController(title: "Error",
            message: "Both fields must be non-empty!",
            preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        // Login
        if loginButton.titleLabel!.text == "Log in" {
            let docRef = self.db.collection("users").document(username)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // Login successful=
                    if document.get("password") as! String == password {
                        let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarController
                                self.navigationController?.pushViewController(tabVC, animated: true)
                        
                        // Store username in singleton
                        PlantsModel.sharedInstance.setUsername(username)
                    }
                    // Incorrect password
                    else {
                        self.passwordField.text = ""
                        
                        let alertController = UIAlertController(title: "Incorrect password",
                        message: "Please try again!",
                        preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                }
                // No such user exists
                else {
                    self.usernameField.text = ""
                    self.passwordField.text = ""
                    
                    let alertController = UIAlertController(title: "Account does not exist",
                    message: "Please sign up instead!",
                    preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
        }
        // Sign up
        else {
            self.db.collection("users").document(username).setData([
                "password": password, "plants": [Plant]()
            ], merge: false) { err in
                // User exists
                if let err = err {
                    print("Error adding user: \(err)")
                    self.usernameField.text = ""
                    self.passwordField.text = ""
                    
                    let alertController = UIAlertController(title: "Account already exists",
                    message: "Please log in instead!",
                    preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                // Successful sign up
                else {
                    print("User \(username) was successfully added!")
                    PlantsModel.sharedInstance.setUsername(username)
                    let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "tabBarVC") as! TabBarController
                            self.navigationController?.pushViewController(tabVC, animated: true)
                }
            }
        }
    }
    
    // Switch between sign up and log in
    @IBAction func switchMode(_ sender: UIButton) {
        // Login -> Sign up
        if loginButton.titleLabel!.text == "Log in" {
            loginButton.setTitle("Sign up", for: .normal)
            messageLabel.setTitle("Already have an account? Log in here!", for: .normal)
        }
        // Sign up -> Log in
        else {
            loginButton.setTitle("Log in", for: .normal)
            messageLabel.setTitle("Don't have an account? Sign up here!", for: .normal)
        }
    }
    
}

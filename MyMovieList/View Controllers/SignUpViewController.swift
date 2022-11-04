//
//  SignUpViewController.swift
//  MyMovieList
//
//  Created by Richard Marquez on 4/19/22.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController
{
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    //Validates fields
    func validateFields() -> String?
    {
        //Check all three fields
        if(usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            return "Please fill in all fields."
        }
        return nil
    }
    
    //Set error label
    func showError(_ message:String)
    {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    //Transition to main view controller
    func transitionToView()
    {
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = mainStoryboardIpad.instantiateViewController(withIdentifier: "MainNavigation") as! UINavigationController
        view.window?.rootViewController = nav
    }
    
    //Sign up button pressed
    @IBAction func signUpTapped(_ sender: Any)
    {
        //Validate fields
        let error = validateFields()
        if error != nil
        {
            //Print error
            showError(error!)
        }
        else
        {
            //Variables
            let username = usernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //Create user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //Error check
                if let err = err
                {
                    //Print error
                    self.showError("Error creating user.")
                }
                else
                {
                    //Save user to firestore
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid).setData( ["username":username, "uid":result!.user.uid]) { (error) in
                        if error != nil
                        {
                            //Print error
                            self.showError("Error: Saving user data.")
                        }
                    }
                    //Set global UID and username
                    Movies.shared.sharedUID = result!.user.uid
                    Movies.shared.sharedUsername = username
                    self.transitionToView()
                }
            }
        }
    }
    
}

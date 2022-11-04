//
//  LoginViewController.swift
//  MyMovieList
//
//  Created by Richard Marquez on 4/19/22.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController
{
    
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
        if(emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
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
    
    @IBAction func loginTapped(_ sender: Any)
    {
        //Variables
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Sign the user in
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil
            {
                //Print error
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.isHidden = false
            }
            else
            {
                //Set global UID 
                Movies.shared.sharedUID = result!.user.uid
                self.transitionToView()
            }
        }
    }
    
    
}

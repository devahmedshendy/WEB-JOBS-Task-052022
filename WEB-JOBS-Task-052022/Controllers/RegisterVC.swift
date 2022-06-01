//
//  RegisterVC.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 31/05/2022.
//

import UIKit

class RegisterVC: BaseScrollableFormVC {

    @IBOutlet weak var firstnameField: FormTextField!
    @IBOutlet weak var lastnameField: FormTextField!
    @IBOutlet weak var emailField: FormTextField!
    @IBOutlet weak var mobileField: FormMobileField!
    @IBOutlet weak var passwordField: FormPasswordField!
    @IBOutlet weak var confirmPasswordField: FormPasswordField!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.helpText = "At least 8 characters"
        firstnameField.feedbackText = "This field is required!"
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        let isRequiredText = "This field is required"
        
        firstnameField.feedbackText = firstnameField.text!.isEmpty ? isRequiredText : ""
        
        lastnameField.feedbackText = lastnameField.text!.isEmpty ? isRequiredText : ""
        
        emailField.feedbackText = emailField.text!.isEmpty ? isRequiredText : ""
        
        passwordField.feedbackText = passwordField.text!.isEmpty ? isRequiredText : ""
        
        confirmPasswordField.feedbackText = confirmPasswordField.text!.isEmpty ? isRequiredText : ""
        
        if firstnameField.text!.isNotEmpty
            && lastnameField.text!.isNotEmpty
            && emailField.text!.isNotEmpty
            && passwordField.text!.isNotEmpty
            && confirmPasswordField.text!.isNotEmpty {
            firstnameField.feedbackText = ""
            lastnameField.feedbackText = ""
            emailField.feedbackText = ""
            passwordField.feedbackText = ""
            confirmPasswordField.feedbackText = ""
            
            print("Navigate to main")
        }
    }
}

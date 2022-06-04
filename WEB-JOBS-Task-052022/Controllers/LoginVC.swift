//
//  LoginVC.swift
//  WEB-JOBS-Task-052022
//
//  Created by Ahmed Shendy on 04/06/2022.
//

import UIKit
import GoogleSignIn

class LoginVC: BaseVC {
    
    // MARK: - Properties
    
    private let signInConfig = GIDConfiguration(clientID: _googleClientID)
    
    @IBOutlet weak var authDetails: UILabel!
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
    }
    
    @IBAction func signInWithGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: self
        ) { user, error in
            guard error == nil else { return }
            guard let user = user,
                  let emailAddress = user.profile?.email,
                  let fullName = user.profile?.name else { return }
            
            user.authentication.do { authentication, error in
                guard error == nil else { return }
                guard let authentication = authentication,
                      let idToken = authentication.idToken else { return }
                
                
                // Send ID token to backend (example below).
                var details = emailAddress
                details += "\n\(fullName)"
                details += "\n\(idToken)"
                
                self.authDetails.text = details
            }
            
        }
    }
}


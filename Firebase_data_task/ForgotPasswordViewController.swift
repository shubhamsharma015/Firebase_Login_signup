//
//  ForgotPasswordViewController.swift
//  Firebase_data_task
//
//  Created by Aryan on 19/05/23.
//

import UIKit
import Firebase
import FirebaseAuth
class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton)
    {
        if let email = emailField.text{
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.showAlert(with: "There is no account with this email")
                print("Password reset error: \(error.localizedDescription)")
            } else {
                    // Password reset email sent successfully
                print("Password reset email sent")
                self.showAlert(with: "reset link send to \(email) address")
            }
        }
    }
        
    }
}


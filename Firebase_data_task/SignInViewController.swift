//
//  SignInViewController.swift
//  Firebase_data_task
//
//  Created by Aryan on 19/05/23.
//

import UIKit
import Firebase
import FirebaseAuth
import MBProgressHUD
class SignInViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func userLogInBtn(_ sender: UIButton){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        guard let email = emailField.text?.trimmingCharacters(in: .whitespaces), let password = PasswordField.text?.trimmingCharacters(in: .whitespaces) else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { AuthDataResult, Error in
            if let error = Error{
                let alert = UIAlertController(title: "User Not Found", message: "user is not registered with ", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .destructive) { action in
                    self.dismiss(animated: true)
                }
                alert.addAction(action)
                MBProgressHUD.hide(for: self.view, animated: true)
                self.present(alert, animated: true)
            }else{
              
                let userInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
                
                self.navigationController?.pushViewController(userInfoVC, animated: true)
                
            }
        }
        
    }

    
    @IBAction func forgotPasswordBtn(_ sender: UIButton)
    {
        let forgotPassVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotPassVC, animated: true)
    }
    
}

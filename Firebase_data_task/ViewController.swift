//
//  ViewController.swift
//  Firebase_data_task
//
//  Created by Aryan on 19/05/23.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func signUpBtnPressed(_ sender:UIButton){
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    @IBAction func signInBtnPressed(_ sender:UIButton){
        let signInVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        navigationController?.pushViewController(signInVC, animated: true)
    }
    @IBAction func forgetPasswordBtnPressed(_ sender:UIButton){
        
    }
}



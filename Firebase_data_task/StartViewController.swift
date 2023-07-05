//
//  StartViewController.swift
//  Firebase_data_task
//
//  Created by Aryan on 22/05/23.
//

import UIKit
import FirebaseAuth
import Firebase
class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkingUser()
    }
    func checkingUser(){
        if Auth.auth().currentUser != nil{
            let userDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
            self.navigationController?.pushViewController(userDetailVC, animated: true)
        }else{
            let startVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(startVC, animated: true)
        }
    }
}

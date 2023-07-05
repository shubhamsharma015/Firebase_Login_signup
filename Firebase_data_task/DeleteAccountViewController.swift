//
//  DeleteAccountViewController.swift
//  Firebase_data_task
//
//  Created by Aryan on 23/05/23.
//

import UIKit
import FirebaseAuth
import Firebase
import MBProgressHUD
class DeleteAccountViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwork: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
     
        
    }
    override func viewWillAppear(_ animated: Bool) {
        email.text = Auth.auth().currentUser?.email
    }

    @IBAction func deleteBtn(_ sender: UIButton){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.authenticateUser()
    }
    
    
    func authenticateUser() {
        guard let user = Auth.auth().currentUser else {
            print("User is not signed in.")
            return
        }
        
       
        let password = passwork.text!
        
        
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: password)
        
        user.reauthenticate(with: credential) { (_, error) in
            if let error = error {
                self.showAlert(with: "Error reauthenticating user: \(error.localizedDescription)")
            } else {
                self.deleteUserData()
            }
        }
    }
    
    
    func deleteUserData(){
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let userID = currentUser.uid
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).delete(){ (error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                currentUser.delete { (error) in
                    if let error = error {
                        print("Error deleting user account: \(error.localizedDescription)")
                    } else {
                        print("User account successfully deleted")
                        let alert = UIAlertController(title: "Alert", message: "Account associated with \(self.email.text!) is deleted successful", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .destructive) { UIAlertAction in
                            let startVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                            self.navigationController?.pushViewController(startVC, animated: true)
                            
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true)
                    }
                }
                
                
                
                
            }
        }
    }

}

    //
    //  UpdateUserViewController.swift
    //  Firebase_data_task
    //
    //  Created by Aryan on 19/05/23.
    //

import UIKit
import Firebase
import FirebaseAuth

class UpdateUserViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
            // Do any additional setup after loading the view.
    }
    
    
    @IBAction func updatedPressed(_ sender: UIButton) {
        if let name = nameField.text, let mobile = mobileField.text, let address = addressField.text{
            guard let currentUser = Auth.auth().currentUser else { return }
            
            let userID = currentUser.uid
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(userID)
            let newData = [
                "name": name,
                "mobile": mobile,
                "address": address]
            
            userRef.updateData(newData) { error in
                if let error = error {
                    print("Error updating user data: \(error.localizedDescription)")
                } else {
                    let userInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
                    self.navigationController?.pushViewController(userInfoVC, animated: true)
                }
            }
        }
    }
    
}

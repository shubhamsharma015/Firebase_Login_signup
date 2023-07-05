    //
    //  UserDetailViewController.swift
    //  Firebase_data_task
    //
    //  Created by Aryan on 19/05/23.
    //

import UIKit
import Firebase
import FirebaseAuth
import MBProgressHUD
import SDWebImage

class UserDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveData()

            // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
 
    }
    
    func retrieveData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        guard let currentUser = Auth.auth().currentUser else {
            print("no user found")
            return }
        
        let userID = currentUser.uid
        let db = Firestore.firestore()
        
        db.collection("users").document(userID).getDocument {[weak self] DocumentSnapshot, Error in
            if let error = Error{
                print("error \(Error?.localizedDescription ?? "error")")
            }
            if let userInfo = DocumentSnapshot?.data(){
                guard let strongself = self else{ return }
                strongself.nameLabel.text = userInfo["name"] as? String
                strongself.mobileLabel.text = userInfo["mobile"] as? String
                strongself.addressLabel.text = userInfo["address"] as? String
                strongself.emailLabel.text = userInfo["email"] as? String
                let imageString = userInfo["imageURL"] as? String
                if let imgUrl = URL(string: imageString!){
                     strongself.profileImage.sd_setImage(with: imgUrl)
                     strongself.profileImage.contentMode = .scaleToFill
                     strongself.profileImage.layer.cornerRadius = strongself.profileImage.frame.height/2.5
                    MBProgressHUD.hide(for: strongself.view, animated: true)
                }
                
            }
        }
//        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    
    @IBAction func updateUserInfo(_ sender: UIButton) {
        let updateInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateUserViewController") as! UpdateUserViewController
        navigationController?.pushViewController(updateInfoVC, animated: true)
    }
    
    @IBAction func logOutBtn(_ sender: UIButton){
        do{
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }catch{
            print(error)
        }
        
    }
    
    @IBAction func deleteUserBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Do you Want to delete \(nameLabel.text!)'s account", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] UIAlertAction in
  
//            let user = Auth.auth().currentUser
//            var credential: AuthCredential
//            credential = EmailAuthCredential.credential(withEmail:"\(user.email)", link:link)
//            user?.reauthenticateAndRetrieveData(with: credential, completion: {(authResult, error) in
//                if let error = error {
//                        // An error happened.
//                }else{
//                        // User re-authenticated.
//                }
//            })
            
            let deleteVC = self?.storyboard?.instantiateViewController(withIdentifier: "DeleteAccountViewController") as! DeleteAccountViewController
            self?.navigationController?.pushViewController(deleteVC, animated: true)
            
            
            
        }
        let cancle = UIAlertAction(title: "cancle", style: .cancel)
        alert.addAction(cancle)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    
    
    
    
   
}

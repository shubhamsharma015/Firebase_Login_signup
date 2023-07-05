    //
    //  SignUpViewController.swift
    //  Firebase_data_task
    //
    //  Created by Aryan on 19/05/23.
    //

import UIKit
import Firebase
import FirebaseAuth
import MBProgressHUD
import FirebaseStorage
class SignUpViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var adressField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
            // Do any additional setup after loading the view.
    }
    
    
    @IBAction func submitBtnPressed(_ sender: UIButton){
        
            //        if let uname = nameField.text, let umobile = mobileField.text, let udress = adressField.text, let uEmail = emailField.text, let uPassword = PasswordField.text{
            //
            //            registerUser(withEmail: uname, mobile: umobile, address: udress, email: uEmail, password: uPassword)
            //        }
        
        if let selectedImage = profileImage.image {
            changingImgToURL(withImage: selectedImage)
            
        } else {self.showAlert(with: "Please select an image")}
    }
    
    @IBAction func uploadImage(_ sender: UIButton){
        let alert = UIAlertController(title: "Select Profile Photo from", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (_) in
            print("Camera Pressed")
            self?.showImagePicker(selectedSource: .camera)
        }
        let libraryAction = UIAlertAction(title: "Gallary", style: .default) {[weak self] (_) in
            print("Library pressed")
            self?.showImagePicker(selectedSource: .photoLibrary)
        }
        let  CancleAction = UIAlertAction(title: "Cancle", style: .default,handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(CancleAction)
        
        present(alert, animated: true)
    }
    
    func showImagePicker(selectedSource: UIImagePickerController.SourceType){
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else{
            print("selected source is'nt available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = selectedSource
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage{
            profileImage.image = selectedImage
            profileImage.contentMode = .scaleAspectFill
        }else{
            print("image not find")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func changingImgToURL(withImage selectedImage: UIImage) {
            //        if let selectedImage = profileImage.image {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let imageRef = Storage.storage().reference().child("image.jpg")
        
            // Get image data
        if let uploadData = selectedImage.jpegData(compressionQuality: 0.8) {
            
                // Upload image to Firebase Cloud Storage
            imageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard error == nil else {
                        // Handle error
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print("Error uploading image: \(error?.localizedDescription ?? "")")
                    return
                }
                
                    // Get full image URL
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                            // Handle error
                        MBProgressHUD.hide(for: self.view, animated: true)
                        print("Error retrieving download URL: \(error?.localizedDescription ?? "")")
                        return
                    }
                    
                        // Register user with the image URL
                    if let uname = self.nameField.text, let umobile = self.mobileField.text, let udress = self.adressField.text, let uEmail = self.emailField.text, let uPassword = self.PasswordField.text{
                        
                        self.registerUserWithEmail(name: uname, mobile: umobile, address: udress, email: uEmail, password: uPassword, imageURL: downloadURL.absoluteString)
                    }else{
                        self.showAlert(with: "all fields are nessessory")
                    }
                }
            }
        }
    }
    
    func registerUserWithEmail(name: String, mobile: String, address: String, email: String, password: String, imageURL: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                return
            }
            
            guard let userID = authResult?.user.uid else {
                print("Error: User ID not available")
                return
            }
            
            let userData = [
                "name": name,
                "mobile": mobile,
                "address": address,
                "email": email,
                "imageURL": imageURL
            ]
            
            let db = Firestore.firestore()
            db.collection("users").document(userID).setData(userData) { error in
                if let error = error {
                    print("Error storing user data: \(error.localizedDescription)")
                    return
                }
                
                print("User data stored in Firestore")
                
                let userInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
                self.navigationController?.pushViewController(userInfoVC, animated: true)
            }
        }
    }
    
}


extension UIViewController{
    func showAlert(with text:String){
        let alert = UIAlertController(title: "hey", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive) { UIAlertAction in
            self.dismiss(animated: true)
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}


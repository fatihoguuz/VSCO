//
//  UploadVC.swift
//  VSCO
//
//  Created by Fatih Oğuz on 19.07.2024.
//

import UIKit
import FirebaseStorage
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var uploadImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
                uploadImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func choosePicture() {
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
            
        }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            uploadImageView.image = info[.originalImage] as? UIImage
            self.dismiss(animated: true, completion: nil)
        }

    @IBAction func uploadButton(_ sender: Any) {
        guard let currentUser = Auth.auth().currentUser else {
            self.makeAlert( message: "User not authenticated")
            return
        }
        
        let uid = currentUser.uid
        
        // Storage
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString // Her fotoğraf için benzersiz bir UUID
            let imageReference = mediaFolder.child("\(uuid).jpeg")
            
            imageReference.putData(data, metadata: nil) { metadata, error in
                if let error = error {
                    self.makeAlert( message: error.localizedDescription)
                    return
                }
                
                imageReference.downloadURL { url, error in
                    if let error = error {
                        self.makeAlert( message: error.localizedDescription)
                        return
                    }
                    
                    guard let imageUrl = url?.absoluteString else {
                        self.makeAlert( message: "URL could not be retrieved")
                        return
                    }
                    
                    // Firestore
                    let fireStore = Firestore.firestore()
                    
                    // Kullanıcıya ait belgeyi UID ile sorgula
                    fireStore.collection("Snaps").whereField("userID", isEqualTo: uid).getDocuments { snapshot, error in
                        if let error = error {
                            self.makeAlert(message: error.localizedDescription)
                            return
                        }
                        
                        if let snapshot = snapshot, !snapshot.isEmpty {
                            for document in snapshot.documents {
                                let documentId = document.documentID
                                
                                if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                    imageUrlArray.append(imageUrl)
                                    let additionalDictionary = ["imageUrlArray": imageUrlArray] as [String: Any]
                                    fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                                        if let error = error {
                                            self.makeAlert(message: error.localizedDescription)
                                        } else {
                                            self.tabBarController?.selectedIndex = 0
                                            self.uploadImageView.image = UIImage(named: "shine")
                                        }
                                    }
                                }
                            }
                        } else {
                            let snapDictionary: [String: Any] = [
                                "imageUrlArray": [imageUrl],
                                "userID": uid,
                                "date": FieldValue.serverTimestamp(),
                                "userName": UserSingleton.sharedUserInfo.username
                            ]
                            
                            fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                if let error = error {
                                    self.makeAlert(message: error.localizedDescription)
                                } else {
                                    self.tabBarController?.selectedIndex = 0
                                    self.uploadImageView.image = UIImage(named: "shine")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

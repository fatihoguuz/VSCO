//
//  MainMenuVC.swift
//  VSCO
//
//  Created by Fatih Oğuz on 19.07.2024.
//

import UIKit
import Firebase
import SDWebImage

class MainMenuVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var snapArray = [Snap]()
    let fireStoreDatabase = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getSnapsFromFirebase()
        getUserInfo()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func getSnapsFromFirebase() {
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "ERror")
            }else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        
                        if let username = document.get("SnapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp{
                                    
                                    let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue())
                                    self.snapArray.append(snap)
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getUserInfo() {
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
            if error != nil{
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
            }else {
                if snapshot?.isEmpty == false && snapshot != nil  {
                    for document in snapshot!.documents {
                        if let username = document.get("username") as? String{
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                    
                }
            }
            
        }
    }
        @IBAction func settingsButton(_ sender: Any) {
            
            performSegue(withIdentifier: "toSettingsVC", sender: nil)
            
        }
    
        func makeAlert(title: String , message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default , handler:  nil)
            alert.addAction(okButton)
            self.present(alert,animated: true , completion: nil)
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainMenuCell
       
        cell.feedUserNameLabel.text = snapArray[indexPath.row].username
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray.last!))
        return cell
    }
}

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
    var chosenSnap : Snap?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getSnapsFromFirebase()
        getUserInfo()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTable()
    }
    
    
    func refreshTable() {
        getSnapsFromFirebase()
        tableView.reloadData()
    }
    
    func getSnapsFromFirebase() {
        fireStoreDatabase.collection("Snaps")
            .whereField("userID", isEqualTo: Auth.auth().currentUser!.uid)
            .order(by: "date", descending: true)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                 //   self.makeAlert( message: error.localizedDescription)
                } else {
                    guard let snapshot = snapshot, !snapshot.isEmpty else {
                        self.makeAlert(message: "No snaps found")
                        return
                    }
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot.documents {
                        if let username = document.get("userName") as? String,
                           let imageUrlArray = document.get("imageUrlArray") as? [String],
                           let date = document.get("date") as? Timestamp {
                            
                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue())
                            self.snapArray.append(snap)
                        } else {
                            self.makeAlert(message: "Invalid snap data")
                        }
                    }
                    print("snapArray Count: \(self.snapArray.count)")
                    self.tableView.reloadData()
                }
            }
    }
    
    func getUserInfo() {
        print("Tetiklendi getUserInfo")
        guard let currentUser = Auth.auth().currentUser else {
            self.makeAlert( message: "User not authenticated")
            return
        }
        
        guard let email = currentUser.email else {
            self.makeAlert(message: "Email not found")
            return
        }
        
        fireStoreDatabase.collection("UserInfo").whereField("Email", isEqualTo: email).getDocuments { (snapshot, error) in
            if let error = error {
                self.makeAlert( message: error.localizedDescription)
            } else {
                guard let snapshot = snapshot, !snapshot.isEmpty else {
                    self.makeAlert(message: "No user info found")
                    return
                }
                
                for document in snapshot.documents {
                    if let username = document.get("Username") as? String {
                        UserSingleton.sharedUserInfo.email = email
                        UserSingleton.sharedUserInfo.username = username
                    } else {
                        self.makeAlert( message: "Username not found in document")
                    }
                }
            }
        }
    }
        @IBAction func settingsButton(_ sender: Any) {
            
            self.performSegue(withIdentifier: "toSettingsVC", sender: nil)
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC"{
            let destinationVC = segue.destination as? SnapVC
            destinationVC?.selectedSnap = chosenSnap
            destinationVC?.selectedName = chosenSnap
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
}

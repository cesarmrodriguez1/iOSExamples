//
//  DishTableViewController.swift
//  FirebaseASample
//
//  Created by César on 25/08/21.
//

import UIKit
import Firebase

class DishTableViewController: UITableViewController{
    
    let userListName = "ListToUsers"
    let reference = Database.database().reference(withPath: "menu-items")
    var referenceObservers: [DatabaseHandle] = []
    
    let usersReference = Database.database().reference(withPath: "online")
    
    //Properties:
    
    var items: [MenuItem] = []
    var user: User?
    var onlineUserCount = UIBarButtonItem()
    var listenerHandle: AuthStateDidChangeListenerHandle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        
        onlineUserCount = UIBarButtonItem(
            title: "1",
            style: .plain,
            target: self,
            action: #selector(onlineUserCountDidTouch))
        onlineUserCount.tintColor = .white
        navigationItem.leftBarButtonItem = onlineUserCount
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        let completed = reference
            .queryOrdered(byChild: "ordered")
            .observe(.value){ snapshot in
                var newItems: [MenuItem] = []
                var counter = 0
                for child in snapshot.children {
                    counter = counter + 1
                    print("Iteration: ")
                    
                    if
                        let snapshot = child as? DataSnapshot,
                        let menuItem = MenuItem(snapshot: snapshot){
                        
                        newItems.append(menuItem)
                    }
                    else{
                        print("Snapshot cannot be filled")
                    }
                }
                self.items = newItems
                self.tableView.reloadData()
            }
    }
    
    override func viewDidDisappear(_ animated: Bool){
        
    }
    
    //TableView:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
    }
    */
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool){
        
    }
    
    //Functions for processing data in TableView
    
    @IBAction func addItemDidTouch(_ sender: AnyObject){
        
    }
    
    @objc func onlineUserCountDidTouch(){
        performSegue(withIdentifier: "SegueName", sender: nil)
    }
    
    @IBAction func signOutDidTouch(_ sender: AnyObject){
        guard let user = Auth.auth().currentUser else{ return}
        
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
        onlineRef.removeValue(){ error, _ in
            if let error = error{
                print("Removing user online failed: \(error)")
                return
            }
            do{
                try Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
            } catch let error{
                print("Removing user online failed: \(error)")
            }
        }
    }
}

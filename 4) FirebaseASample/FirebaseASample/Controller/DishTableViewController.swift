//
//  DishTableViewController.swift
//  FirebaseASample
//
//  Created by César on 02/02/21.
//

import UIKit
import Firebase

class DishTableViewController: UITableViewController {
  // MARK: Constants
  let userListName = "ListToUsers"
  let reference = Database.database().reference(withPath: "menu-items")
  var referenceObservers: [DatabaseHandle] = []

  let usersReference = Database.database().reference(withPath: "online")
  var usersReferenceObservers: [DatabaseHandle] = []

  // MARK: Properties
  var items: [MenuItem] = []
  var user: User?
  var onlineUserCount = UIBarButtonItem()
  var listenerHandle: AuthStateDidChangeListenerHandle?

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let completed = reference
      .queryOrdered(byChild: "ordered")
      .observe(.value) { snapshot in
        var newItems: [MenuItem] = []
        var counter = 0
        for child in snapshot.children {
            counter = counter + 1
            print("Iteration: \(String(format: "%d", counter))")
          if
            let snapshot = child as? DataSnapshot,
            let menuItem = MenuItem(snapshot: snapshot) {
            print("ITEMS ARE BEING INCLUDED")
            newItems.append(menuItem)
          }
          else{
            print(snapshot.value as Any)
            print("something went wrong")
          }
        }
        self.items = newItems
        self.tableView.reloadData()
      }
    referenceObservers.append(completed)
    
    listenerHandle = Auth.auth().addStateDidChangeListener{_, user in
        guard let user = user else{ return}
        
        self.user = User(authData: user)
        
        let currentUserRef = self.usersReference.child(user.uid)
        currentUserRef.setValue(user.email)
        currentUserRef.onDisconnectRemoveValue()
    }
    
    let users = usersReference.observe(.value){ snapshot in
        if snapshot.exists(){
            self.onlineUserCount.title = snapshot.childrenCount.description
        }
        else{
            self.onlineUserCount.title = "0"
        }
    }
    usersReferenceObservers.append(users)
    
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    referenceObservers.forEach(reference.removeObserver(withHandle:))
    referenceObservers = []
    usersReferenceObservers.forEach(usersReference.removeObserver(withHandle:))
    usersReferenceObservers = []
    guard let handle = listenerHandle else { return}
    Auth.auth().removeStateDidChangeListener(handle)
  }

  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let menuItem = items[indexPath.row]
    
    cell.textLabel?.text = menuItem.name
    cell.detailTextLabel?.text = String(format: "%f", menuItem.price)
    
    toggleCellCheckbox(cell, isCompleted: menuItem.ordered)
    
    return cell
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete{
        let menuItem = items[indexPath.row]
        menuItem.reference?.removeValue()
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return}
    let menuItem = items[indexPath.row]
    let toggledCompletion = !menuItem.ordered
    
    toggleCellCheckbox(cell, isCompleted: toggledCompletion)
    menuItem.reference?.updateChildValues(["ordered" : toggledCompletion])

  }

  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
    if !isCompleted{
        cell.accessoryType = .none
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .black
    }
    else{
        cell.accessoryType = .checkmark
        cell.textLabel?.textColor = .gray
        cell.detailTextLabel?.textColor = .gray
    }
  }

  // MARK: Add Item
  @IBAction func addItemDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(
        title: "Menu Item",
        message: "Add an item",
        preferredStyle: .alert
    )
    
    alert.addTextField()
    alert.addTextField()
    
    alert.textFields?[0].placeholder = "Enter dish name"
    alert.textFields?[1].placeholder = "Enter price"
    
    let saveAction = UIAlertAction(title: "Save", style: .default){_ in
        guard
            let name = alert.textFields?[0].text,
            let price = alert.textFields?[1].text
        else { return}
        
        let menuItem = MenuItem(
            name: name,
            price: (price as NSString).doubleValue,
            ordered: false
        )
        
        //Reference:
        let menuItemReference = self.reference.child(name.lowercased())
        
        menuItemReference.setValue(menuItem.toAnyObject())
    }
    
    let cancelAction = UIAlertAction(
        title: "Cancel",
        style: .cancel)
    
    alert.addTextField()
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
    
  }
    
  @objc func onlineUserCountDidTouch() {
    performSegue(withIdentifier: userListName, sender: nil)
  }
    
    
    // MARK: Actions
    @IBAction func signOutDidTouch(_ sender: AnyObject) {
      guard let user = Auth.auth().currentUser else { return }

      let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
      onlineRef.removeValue { error, _ in
        if let error = error {
          print("Removing online failed: \(error)")
          return
        }
        do {
          try Auth.auth().signOut()
          self.navigationController?.popToRootViewController(animated: true)
        } catch let error {
          print("Auth sign out failed: \(error)")
        }
      }
    }
    
}

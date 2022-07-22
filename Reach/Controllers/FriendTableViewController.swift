//
//  FriendTableViewController.swift
//  Reach
//
//  Created by Zach Davis on 7/21/22.
//

import UIKit
import CoreData

class FriendTableViewController: UITableViewController {

    var friendArray = [Friend]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.friendCellName, bundle: nil), forCellReuseIdentifier: K.friendCellIdentifier)
        
        loadFriends()
        
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.friendCellIdentifier, for: indexPath) as! FriendCell
        
        let fullNameString = "\(self.friendArray[indexPath.row].firstName!) \(self.friendArray[indexPath.row].lastName!)"
        cell.fullNameLabel.text = fullNameString
        
        if friendArray[indexPath.row].reachInterval == 0 {
            cell.reachIntervalLabel.text = "No Reach Reminder Set"
        } else {
            let reachString = "Every \(friendArray[indexPath.row].reachInterval) days"
            cell.reachIntervalLabel.text = reachString
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.contactsIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ContactViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedFriend = friendArray[indexPath.row]
        }
    }
    
    
    //MARK: - data manipulation methods
    
    func saveFriends() {
        
        do {
            try context.save()
        } catch {
            print("error attempting to save context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadFriends(with request: NSFetchRequest<Friend> = Friend.fetchRequest(), predicate: NSCompoundPredicate? = nil) {
        
        if predicate != nil {
            request.predicate = predicate
        }
        
        do {
            friendArray = try context.fetch(request)
        } catch {
            print("error loading friends \(error)")
        }
        
        tableView.reloadData()
    }
    
//    DELETE
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Remove") { action, view, completionHandler in
            
//            who to remove
            let friendToRemove = self.friendArray[indexPath.row]
            
//            removing from array
            self.context.delete(friendToRemove)
            
            self.saveFriends()
            
            self.loadFriends()
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    

    //MARK: - Adding Friends

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var firstNameTextField = UITextField()
        var lastNameTextField = UITextField()
        var phoneNumberTextField = UITextField()
        var emailTextField = UITextField()
        var reachTextField = UITextField()
        
        let alert = UIAlertController(title: "Add a Friend", message: "message goes here", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Friend", style: .default) { action in
            
            let newFriend = Friend(context: self.context)
            
            newFriend.firstName = firstNameTextField.text
            newFriend.lastName = lastNameTextField.text
            
            let phoneNumberEntry : Int64 = Int64(phoneNumberTextField.text!)!
            newFriend.phoneNumber = phoneNumberEntry
            
            newFriend.email = emailTextField.text
            
            let reachIntervalEntry : Int64 = Int64(reachTextField.text!)!
            newFriend.reachInterval = reachIntervalEntry
            
            self.friendArray.append(newFriend)
            
            self.saveFriends()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "First Name"
            firstNameTextField = alertTextField
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Last Name"
            lastNameTextField = alertTextField
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Phone Number"
            phoneNumberTextField = alertTextField
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Emai"
            emailTextField = alertTextField
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Reach Out Interval (days)"
            reachTextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

//MARK: - Search Bar Methods
    
    
extension FriendTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchRequest : NSFetchRequest<Friend> = Friend.fetchRequest()
        
        
        let firstNamePredicate = NSPredicate(format: "firstName CONTAINS[cd] %@", searchBar.text!)
        
        let lastNamePredicate = NSPredicate(format: "lastName CONTAINS[cd] %@", searchBar.text!)
        
        
        let searchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [firstNamePredicate, lastNamePredicate])
        
        let sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true), NSSortDescriptor(key: "lastName", ascending: false)]
        
        
        searchRequest.sortDescriptors = sortDescriptors
        
        searchRequest.predicate = searchPredicate
        
        loadFriends(with: searchRequest, predicate: searchPredicate)
        
        print("search ran")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadFriends()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

//
//  ContactViewController.swift
//  Reach
//
//  Created by Zach Davis on 7/21/22.
//

import UIKit
import CoreData

class ContactViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedFriend : Friend? {
        didSet {
            print("friend set \(selectedFriend!.firstName!)")
        }
    }
    
    @IBOutlet weak var reachIntervalField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reachIntervalField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        phoneNumberField.delegate = self
        emailField.delegate = self

        if let friend = selectedFriend {
            insertFriendInfo(with: friend)
        }
        
    }

    
    @IBAction func removePressed(_ sender: UIButton) {
        
        if let friend = self.selectedFriend {
            self.context.delete(friend)
        }
        
        saveFriendInfo()
        
        navigationController?.popToRootViewController(animated: true)

        
        }
    }
    


extension ContactViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("did end editing")
        print(textField.text!)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("did should end editing")
        print(textField.text!)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("did run should return")
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func insertFriendInfo(with friend: Friend) {
        
        firstNameField.text = friend.firstName
        lastNameField.text = friend.lastName
        emailField.text = friend.email
        
        let phoneNumberStr : String = String(friend.phoneNumber)
        phoneNumberField.text = phoneNumberStr
        
        let reachIntervalStr : String = String(friend.reachInterval)
        reachIntervalField.text = reachIntervalStr

    }
    
    func saveFriendInfo() {
        
        do {
            try context.save()
        } catch {
            print("error saving friend info \(error)")
        }
    }
    
}

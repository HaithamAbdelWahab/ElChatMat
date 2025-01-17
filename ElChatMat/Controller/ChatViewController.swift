//
//  ChatViewController.swift
//  ElChatMat
//
//  Created by Haitham Abdel Wahab on 2/11/19.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
   
  

    
        // Declare instance variables here
    var messageArray : [Message] = [Message]()
        
        // We've pre-linked the IBOutlets
        @IBOutlet var heightConstraint: NSLayoutConstraint!
        @IBOutlet var sendButton: UIButton!
        @IBOutlet var messageTextfield: UITextField!
        @IBOutlet var messageTableView: UITableView!
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            //TODO: Set yourself as the delegate and datasource here:
            
            messageTableView.delegate = self
            messageTableView.dataSource = self
            
            //TODO: Set yourself as the delegate of the text field here:
            messageTextfield.delegate = self

            
            
            //TODO: Set the tapGesture here:
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
            messageTableView.addGestureRecognizer(tapGesture)
            
            
            //TODO: Register your MessageCell.xib file here:
            
            messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
            configureTableView()
            retrieveMessages()
            
            //to make a litle vertically space between cells
            messageTableView.separatorStyle = .none
        }
        
        ///////////////////////////////////////////

    
        //MARK: - TableView DataSource Methods
        
        
        
        //TODO: Declare cellForRowAtIndexPath here:
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        
        if cell.senderUsername.text == FIRAuth.auth()?.currentUser?.email as String? {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
            
        }else {
            cell.avatarImageView.backgroundColor = UIColor.flatGray()
            cell.messageBackground.backgroundColor = #colorLiteral(red: 0.9018011689, green: 0.9016475081, blue: 0.9222540259, alpha: 1)
            cell.messageBody.textColor = UIColor.black
        }
        return cell
    }
    
        
        //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
        
    }
    
        
        
        //TODO: Declare tableViewTapped here:
        
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
        
        //TODO: Declare configureTableView here:
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
        
        
        ///////////////////////////////////////////
        
        //MARK:- TextField Delegate Methods
        
        
        
        
        //TODO: Declare textFieldDidBeginEditing here:
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
        
        
        //TODO: Declare textFieldDidEndEditing here:
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
        
        ///////////////////////////////////////////
        
        
        //MARK: - Send & Recieve from Firebase
        
        
        
        
        
        @IBAction func sendPressed(_ sender: AnyObject) {
            
            messageTextfield.endEditing(true)
            //TODO: Send the message to Firebase and save it in our database
            messageTextfield.isEnabled = false
            sendButton.isEnabled = false
            
            let messagesDb = FIRDatabase.database().reference().child("Messages")
            
            let messageDictionary = ["Sender": FIRAuth.auth()?.currentUser?.email,"MessageBody": messageTextfield.text!]
            
            messagesDb.childByAutoId().setValue(messageDictionary) {
                (error, ref) in
                
                if error != nil {
                    print(error!)
                }
                else {
                  //  print("Message saved successfully")
                    
                    self.messageTextfield.isEnabled = true
                    self.sendButton.isEnabled = true
                    
                    self.messageTextfield.text = ""
                    
                }
            }
            
            //MARK - autoscroll to the bottom to show the latest masagges after sent any massage
                
                let numberOfSections = self.messageTableView.numberOfSections
                let numberOfRows = self.messageTableView.numberOfRows(inSection: numberOfSections-1)
                
                let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
                self.messageTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)
    
            
            
            
            
        }
        
        //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages() {
        
        let messageDb = FIRDatabase.database().reference().child("Messages")

        messageDb.observe(.childAdded, with: { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
//            print(text, sender)
                        let message = Message()
            
                        message.messageBody = text
                        message.sender = sender
            
                        self.messageArray.append(message)
                        self.configureTableView()
                        self.messageTableView.reloadData()
            
        })

        
    }
        
        
        
        
        
        @IBAction func logOutPressed(_ sender: AnyObject) {
            
            //TODO: Log out the user and send them back to WelcomeViewController
            
            do {
         try   FIRAuth.auth()?.signOut()
            
                
            }catch {
                print("error: there was a problem signing out")
            }
            
            guard(navigationController?.popToRootViewController(animated: true)) != nil
                else {
                    print("No View Controllers to pop off")
                    
                    return
            }
        
        
        
}

}

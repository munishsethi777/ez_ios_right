//
//  MessageTableViewController.swift
//  RightManagement
//
//  Created by Munish Sethi on 10/10/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {

    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMessages()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MessageTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell
        let message = messages[indexPath.row]
        cell?.messageTitle.text = message.messageTitle
        cell?.messageDescription.text = message.messageDescription
        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            print("Edit tapped")
        })
        editAction.backgroundColor = UIColor.blue
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.messages.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with:.fade)
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [editAction, deleteAction]
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func loadMessages(){
        let msg1 = Message(messageTitle: "This is first message",messageDescription: "This is message details")
        let msg2 = Message(messageTitle: "This is second message",messageDescription: "This is second details")
        let msg3 = Message(messageTitle: "This is second message",messageDescription: "This is second details")
        let msg4 = Message(messageTitle: "This is second message",messageDescription: "This is second details")
        let msg5 = Message(messageTitle: "This is second message",messageDescription: "This is second details")
        let msg6 = Message(messageTitle: "This is second message",messageDescription: "This is second details")
        let msg7 = Message(messageTitle: "This is second message",messageDescription: "This is second details")
        let msg8 = Message(messageTitle: "This is second message",messageDescription: "This is second details")
        let msg9 = Message(messageTitle: "This is second message",messageDescription: "This is second details")
        let msg10 = Message(messageTitle: "This is second message",messageDescription: "This is second details")
        let msg11 = Message(messageTitle: "This is second message",messageDescription: "This is second details")
        messages += [msg1,msg2,msg3,msg4,msg5,msg6,msg7,msg8,msg9,msg10,msg11]
    }

}

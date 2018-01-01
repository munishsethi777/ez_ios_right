//
//  MessageTableViewController.swift
//  RightManagement
//
//  Created by Munish Sethi on 10/10/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit

class MessageTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var messageTableView: UITableView!
    var messages = [Message]()
    var loggedInUserSeq: Int = 0
    var loggedInCompanySeq: Int = 0
    var messageCount: Int = 0
    var selectedMessageUserSeq:Int = 0
    var selectedMessageUserName:String!
    var selectedMessageUserType:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        loggedInCompanySeq = PreferencesUtil.sharedInstance.getLoggedInCompanySeq()
        getMessages()
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

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        selectedMessageUserSeq = message.chattingUserSeq
        selectedMessageUserType = message.chattingUserType
        selectedMessageUserName = message.messageTitle
        self.performSegue(withIdentifier: "MessageDetailViewController", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MessageTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell
        let message = messages[indexPath.row]
        cell?.messageTitle.text = message.messageTitle
        cell?.messageDescription.text = message.messageDescription
        cell?.messageDateLabel.text = message.date
        let imagePath = message.userImageUrl
        if let url = NSURL(string: imagePath) {
            if let data = NSData(contentsOf: url as URL) {
                cell?.messageImageView.image = UIImage(data: data as Data)
                cell?.messageImageView.layer.cornerRadius = (cell?.messageImageView.frame.height)! / 2
                cell?.messageImageView.clipsToBounds = true
            }
        }
        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
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
    func getMessages(){
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_MESSSAGES, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadMessages(response: json)
                    }else{
                        self.showAlert(message: message!)
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description)
            }
        })
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "API Exception", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func loadMessages(response: [String: Any]){
        let messageJsonArr = response["messages"] as! [Any];
        messageCount = messageJsonArr.count
        for i in 0..<messageJsonArr.count{
            let messageJson = messageJsonArr[i] as! [String: Any]
            let title = messageJson["messageText"] as! String
            let dated = messageJson["dated"] as! String
            let name = messageJson["name"] as! String
            let userImage = messageJson["userImage"] as! String
            let userImageUrl = StringConstants.WEB_API_URL + userImage
            let userType = messageJson["userType"] as! String
            let userSeq = messageJson["userSeq"] as! String
            let msg = Message(messageTitle:name,messageDescription: title,userImageUrl:userImageUrl,date:dated,chattingUserSeq:Int(userSeq)!,chattingUserType:userType)
            messages.append(msg)
        }
        messageTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "MessageDetailViewController") {
            let destinationVC:MessageChatController = segue.destination as! MessageChatController
            destinationVC.chatUserSeq = selectedMessageUserSeq
            destinationVC.charUserType = selectedMessageUserType
            destinationVC.chattingUserName = selectedMessageUserName
        }
    }
    
    

}

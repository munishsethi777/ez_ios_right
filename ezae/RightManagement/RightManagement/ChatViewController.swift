//
//  ChatViewController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 04/01/18.
//  Copyright © 2018 Munish Sethi. All rights reserved.
//

import UIKit
class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    var chatRoomModel = [ChatModel]()
    var loggedInUserSeq: Int = 0
    var loggedInCompanySeq: Int = 0
    var messageCount: Int = 0
    var selectedChatroomId:Int = 0
    var selctedChatroomName:String!
    var refreshControl:UIRefreshControl!
    var  progressHUD: ProgressHUD!
    var isCalledFromDashboard:Bool = false
    override func viewDidLoad(){
        super.viewDidLoad()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        loggedInCompanySeq = PreferencesUtil.sharedInstance.getLoggedInCompanySeq()
        tableView.dataSource = self
        tableView.delegate = self
        getChatRooms()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        tableView.refreshControl = refreshControl
        progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
    }
    
    func refreshView(refreshControl: UIRefreshControl) {
        getChatRooms()
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
        return chatRoomModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatroom = chatRoomModel[indexPath.row]
        selectedChatroomId = chatroom.seq
        selctedChatroomName = chatroom.title
        self.performSegue(withIdentifier: "ChatroomDetailViewController", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ChatRoomTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatRoomTableViewCell
        let chatroom = chatRoomModel[indexPath.row]
        cell?.chatroomTitle.text = chatroom.title
        let imageUrl = chatroom.imageUrl
        if let url = NSURL(string: imageUrl) {
            if let data = NSData(contentsOf: url as URL) {
                cell?.chatroomImageView.image = UIImage(data: data as Data)
                cell?.chatroomImageView.layer.cornerRadius = (cell?.chatroomImageView.frame.height)! / 2
                cell?.chatroomImageView.clipsToBounds = true
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }


    func getChatRooms(){
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_CHATROOMS, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadChatrooms(response: json)
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
    
    private func loadChatrooms(response: [String: Any]){
        let messageJsonArr = response["chatrooms"] as! [Any];
        messageCount = messageJsonArr.count
        for i in 0..<messageJsonArr.count{
            let messageJson = messageJsonArr[i] as! [String: Any]
            let seq = messageJson["seq"] as! String
            let title = messageJson["title"] as! String
            let userImage = messageJson["imagepath"] as! String
            let userImageUrl = StringConstants.WEB_API_URL + userImage
            let chatRoom = ChatModel.init(seq: Int(seq)!, title: title, imageUrl: userImageUrl)
            chatRoomModel.append(chatRoom)
        }
        progressHUD.hide()
        refreshControl.endRefreshing()
        tableView.reloadData()
        if(isCalledFromDashboard){
            self.performSegue(withIdentifier: "ChatroomDetailViewController", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "ChatroomDetailViewController") {
            let destinationVC:ChatDetailController = segue.destination as! ChatDetailController
            destinationVC.chatRoomId = selectedChatroomId
            destinationVC.chatRoomName = selctedChatroomName
        }
    }
    
}

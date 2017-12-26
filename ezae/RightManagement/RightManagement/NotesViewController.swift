//
//  NotesViewController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 24/12/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit
class NotesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var notesCount:Int = 0
    var loggedInUserSeq:Int = 0
    var loggedInCompanySeq:Int = 0
    var notes:[Notes]=[]
    
   
    @IBOutlet weak var notesTableView: UITableView!
    override func viewDidLoad() {
        loggedInCompanySeq = PreferencesUtil.sharedInstance.getLoggedInCompanySeq()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        getNotes()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "NotesTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NotesTableViewCell
        let note = notes[indexPath.row]
        cell?.titleLabel.text = note.title
        cell?.dateTime.text = note.dateTime
        return cell!
    }
    
    func getNotes(){
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_NOTIFICATION, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadNotes(response: json)
                    }else{
                        self.showAlert(message: message!,title:"Failed")
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description,title:"Exception")
            }
        })
    }
    
    func loadNotes(response:[String: Any]){
        let notesArr = response["notes"] as! [Any]
        self.notesCount = notesArr.count
        for i in 0..<notesArr.count{
            let note = notesArr[i] as! [String: Any]
            let noteSeq = note["seq"] as! String;
            let noteDetails = note["details"] as! String;
            let noteCreatedOn = note["createdon"] as! String;
            let noteObj = Notes.init(seq: Int(noteSeq)!, title: noteDetails, dateTime: noteCreatedOn)
            notes.append(noteObj)
            notesTableView.reloadData()
        }
    }
    
    func showAlert(message: String,title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

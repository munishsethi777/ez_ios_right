//
//  UpdateProfileViewController.swift
//  RightManagement
//
//  Created by Munish Sethi on 04/01/18.
//  Copyright © 2018 Munish Sethi. All rights reserved.
//

import UIKit
class UpdateProfileViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var userImageView: UIImageView!
    var loggedInUserSeq:Int = 0
    var loggedInCompanySeq:Int = 0
    var editingTextField:UITextField!
    var customFields:[Any]!
    var progressHUD: ProgressHUD!
    var picker:UIImagePickerController?=UIImagePickerController()
    var isImageSet:Bool = false
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    override func viewDidLoad() {
        loggedInCompanySeq = PreferencesUtil.sharedInstance.getLoggedInCompanySeq()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        getUserFields()
        progressHUD = ProgressHUD(text: "Loading")
        self.view.addSubview(progressHUD)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UpdateProfileViewController.tapGesture(gesture:)))
        //userImageView.addGestureRecognizer(tapGesture)
        userImageView.isUserInteractionEnabled = true
        picker?.delegate = self
    }
    func tapGesture(gesture: UIGestureRecognizer) {
        let alert:UIAlertController = UIAlertController(title: "Profile Picture Options", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let gallaryAction = UIAlertAction(title: "Open Gallary", style: UIAlertActionStyle.default) {
            UIAlertAction in self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in self.cancel()
        }
        
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }

    @IBAction func updateImageTapped(_ sender: Any) {
        let alert:UIAlertController = UIAlertController(title: "Profile Picture Options", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let gallaryAction = UIAlertAction(title: "Open Gallery", style: UIAlertActionStyle.default) {
            UIAlertAction in self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in self.cancel()
        }
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openGallary() {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImageView.contentMode = .scaleAspectFit
            userImageView.image = pickedImage
            isImageSet = true
        }
        dismiss(animated: true, completion: nil)
    }
    func cancel(){
        print("Cancel Clicked")
    }
    
    
    @IBAction func updateProfileAction(_ sender: Any) {
        progressHUD.text = "Updating"
        progressHUD.show()
        var customFieldValues = [String:Any]()
        var emailId = ""
        for view in mainScrollView.subviews{
            if let textField = view as? UITextField {
                if(textField.tag == 0){
                    emailId = textField.text!
                }else{
                    customFieldValues[String(textField.tag)] = textField.text!
                }
            }
        }
        var jsonData = [String:Any]()
        jsonData["emailId"] = emailId
        jsonData["customFields"] = customFieldValues
        let jsonString = ModuleProgressMgr.sharedInstance.toJsonString(jsonObject:jsonData)
        let customFieldsString = jsonString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let args: [Any] = [self.loggedInUserSeq,self.loggedInCompanySeq, customFieldsString]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.UPDATE_USER_PROFILE, args: args)
        var success : Int = 0
        var message : String? = nil
        
        ServiceHandler.instance().makeAPICallImage(url: apiUrl, method: HttpMethod.POST,chosenImage:userImageView.image!, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.progressHUD.hide()
                        self.showAlert(message: message!,title:"Success")
                    }else{
                        self.showAlert(message: message!,title:"Failed")
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description,title:"Exception")
            }
        })
        
    }
    func getUserFields(){
        let args: [Int] = [self.loggedInUserSeq,self.loggedInCompanySeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_USER_DETAIL, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadControls(json: json)
                    }else{
                        self.showAlert(message: message!,title:"Failed")
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description,title:"Exception")
            }
        })
    }
    func loadControls(json:[String: Any]){
        let userDetail = json["userDetail"] as! [String : Any]
        customFields = userDetail["customFields"] as! [Any]
        let screenWidth = UIScreen.main.bounds.width
        var y:CGFloat = 180
        let label = UILabel(frame: CGRect(x:10,y:y,width:100,height:50))
        label.text = "Email"
        label.font = UIFont(name:"Arial",size:12.00)
        mainScrollView.addSubview(label)
        let textField = UITextField(frame: CGRect(x:110,y:y + 10,width:screenWidth - 120,height:30))
        textField.font = UIFont(name:"Arial",size:12.00)
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.text = userDetail["emailid"] as? String
        mainScrollView.addSubview(textField)
        let userImageName = userDetail["userimage"] as? String
        if(userImageName != nil){
            let userImageUrl = StringConstants.USER_IMAGE_URL + userImageName!
            if let url = NSURL(string: userImageUrl) {
                if let data = NSData(contentsOf: url as URL) {
                    let img = UIImage(data: data as Data)
                    userImageView.image = img
                }
            }
        }
        y = y + 50
        for customField in customFields {
            let fieldJson = customField as! [String:Any]
            if(fieldJson["fieldType"] as! String != "Image"){
                let label = UILabel(frame: CGRect(x:10,y:y,width:100,height:50))
                label.text = fieldJson["fieldTitle"] as! String
                label.font = UIFont(name:"Arial",size:12.00)
                label.numberOfLines = 2
                mainScrollView.addSubview(label)
                let textField = UITextField(frame: CGRect(x:110,y:y + 10,width:screenWidth - 120,height:30))
                textField.font = UIFont(name:"Arial",size:12.00)
                textField.borderStyle = UITextBorderStyle.roundedRect
                textField.text = fieldJson["fieldValue"] as? String
                let fieldSeq = fieldJson["fieldSeq"] as! String
                textField.tag = Int(fieldSeq)!
                if(fieldJson["fieldType"] as! String == "Text"  || fieldJson["fieldType"] as! String == "email" || fieldJson["fieldType"] as! String == "Numeric"){
                }else if(fieldJson["fieldType"] as! String == "Date"){
                    textField.addTarget(self, action: #selector(editingChanged), for: .editingDidBegin)
                }
                mainScrollView.addSubview(textField)
                
                y = y + 50
            }
        }
        progressHUD.hide()
        mainScrollView.contentSize = CGSize(width: mainScrollView.contentSize.width, height:y+10)
    }
    
    func editingChanged(textField: UITextField) {
        editingTextField = textField
        let dateStr = editingTextField.text!
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for:.valueChanged)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let dated = dateFormatter.date(from:dateStr)
        if(dated != nil){
            datePickerView.setDate(dated!, animated: true)
        }
    }
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        editingTextField.text = dateFormatter.string(from: sender.date)
    }
    func showAlert(message: String,title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

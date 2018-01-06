//
//  UpdateProfileViewController.swift
//  RightManagement
//
//  Created by Munish Sethi on 04/01/18.
//  Copyright © 2018 Munish Sethi. All rights reserved.
//

import UIKit
class UpdateProfileViewController:UIViewController{
    var loggedInUserSeq:Int = 0
    var loggedInCompanySeq:Int = 0
    var editingTextField:UITextField!
    var customFields:[Any]!
    @IBOutlet weak var mainScrollView: UIScrollView!
    override func viewDidLoad() {
        loggedInCompanySeq = PreferencesUtil.sharedInstance.getLoggedInCompanySeq()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        getUserFields()
    }
    @IBAction func updateProfileAction(_ sender: Any) {
        var customFieldValues = [Int:String]()
        for view in mainScrollView.subviews{
            if let textField = view as? UITextField {
                customFieldValues[textField.tag] = textField.text!
            }
        }
        let customFieldsString = customFieldValues.map{ "\($0):\($1)" }.joined(separator: ",")
        let args: [Any] = [self.loggedInUserSeq,self.loggedInCompanySeq, customFieldsString]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.UPDATE_USER_PROFILE, args: args)
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
        var y:CGFloat = 10
        
        let screenWidth = UIScreen.main.bounds.width
        for customField in customFields {
            let fieldJson = customField as! [String:Any]
            let label = UILabel(frame: CGRect(x:10,y:y,width:100,height:50))
            label.text = fieldJson["fieldTitle"] as! String
            label.font = UIFont(name:"Arial",size:12.00)
            label.numberOfLines = 2
            mainScrollView.addSubview(label)
            let textField = UITextField(frame: CGRect(x:110,y:y + 10,width:screenWidth - 120,height:30))
            textField.font = UIFont(name:"Arial",size:12.00)
            textField.borderStyle = UITextBorderStyle.roundedRect
            textField.text = fieldJson["fieldValue"] as! String
            let fieldSeq = fieldJson["fieldSeq"] as! String
            textField.tag = Int(fieldSeq)!
            if(fieldJson["fieldType"] as! String == "Text"  || fieldJson["fieldType"] as! String == "email" || fieldJson["fieldType"] as! String == "Numeric"){
            }else if(fieldJson["fieldType"] as! String == "Date"){
                textField.addTarget(self, action: #selector(editingChanged), for: .editingDidBegin)
            }
            mainScrollView.addSubview(textField)
            
            y = y + 50
        }
        mainScrollView.contentSize = CGSize(width: mainScrollView.contentSize.width, height:y+10)
    }
    
    func editingChanged(textField: UITextField) {
        editingTextField = textField
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        textField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for:.valueChanged)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY hh:mm a"
        dateFormatter.timeZone = TimeZone.init(identifier: "IST")
        let dated = dateFormatter.date(from:editingTextField.text!)
        datePickerView.setDate(dated!, animated: true)
    }
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY hh:mm a"
        editingTextField.text = dateFormatter.string(from: sender.date)
    }
    func showAlert(message: String,title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

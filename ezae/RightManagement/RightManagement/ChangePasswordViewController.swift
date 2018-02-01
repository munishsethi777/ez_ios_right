//
//  ChangePasswordViewController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 24/12/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit
class ChangePassworViewController: UIViewController{
    
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitTapped(_ sender: Any) {
        if(isValidate()){
            exceuteChangePassword()
        }else{
            showAlert(message: "Confirm Password should match with new password", title: "Failed")
        }
    }
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var oldPasswordText: UITextField!
    var loggedInUserSeq:Int = 0
    var loggedInCompanySeq:Int = 0
    
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBAction func updatePasswordTapped(_ sender: Any) {
        if(isValidate()){
            exceuteChangePassword()
        }else{
            showAlert(message: "Confirm Password should match with new password", title: "Failed")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isEnabled = false
        updateButton.isEnabled = false
        confirmPassword.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        newPasswordText.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        oldPasswordText.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        loggedInUserSeq =  PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        loggedInCompanySeq = PreferencesUtil.sharedInstance.getLoggedInCompanySeq()
    }
    
    func showAlert(message: String,title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let confirmPassword = confirmPassword.text, !confirmPassword.isEmpty,
            let newPassword = newPasswordText.text, !newPassword.isEmpty,
            let oldPassword = oldPasswordText.text, !oldPassword.isEmpty
            else {
                self.submitButton.isEnabled = false
                self.updateButton.isEnabled = false
                return
        }
        submitButton.isEnabled = true
        updateButton.isEnabled = true
    }
    
    func exceuteChangePassword(){
        let args: [Any] = [self.loggedInUserSeq,self.loggedInCompanySeq,oldPasswordText.text!,newPasswordText.text!]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.CHANGE_PASSWORD, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.showAlert(message: message!,title:"Success")
                        self.reset()
                    }else{
                        self.showAlert(message: message!,title:"Failed")
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description,title:"Exception")
            }
        })
    }
    
    func isValidate()->Bool{
        return newPasswordText.text == confirmPassword.text
    }
    
    private func reset(){
        confirmPassword.text = ""
        newPasswordText.text = ""
        oldPasswordText.text = ""
    }
}

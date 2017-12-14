//
//  PageItemController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 08/12/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit

class PageItemController: UIViewController, SSRadioButtonControllerDelegate{
    func didSelectButton(selectedButton: UIButton?) {
    }
    var radioButtonController: SSRadioButtonsController?
   
    @IBOutlet weak var quesTitle: UILabel!
    var itemIndex: Int = 0 // ***
    var questionTitleText: String = ""
    var moduleJson: [String: Any] = [:]
    var questionJson: [String: Any] = [:]
    var imageName: String = ""
    var questionType: String = ""
    var options: [Any] = []
    var pageNo: Int = 0
    var parentController: LaunchModuleViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let questionTitle = questionJson["title"] as! String
        quesTitle.text = String(pageNo) + ". " + questionTitle
       // parentController.setPaggerLabel(page: pageNo)
        questionType = questionJson["type"] as! String;
        options = questionJson["answers"] as! [Any];
        if(questionType == StringConstants.SINGLE_TYPE_QUESTION){
            addRadioViews()
        }else if(questionType == StringConstants.MULTI_TYPE_QUESTION){
            addCheckboxViews()
        }else if(questionType == StringConstants.LONG_TYPE_QUESTION){
            addTextView()
        }else if(questionType == StringConstants.YES_NO_TYPE_QUESTION){
            addSwitchView()
        }else if(questionType == StringConstants.WEB_PAGE_TYPE_QUESTION
            || questionType == StringConstants.MEDIA_TYPE_QUESTION){
            addWebView()
        }else if(questionType == StringConstants.DOC_TYPE_QUESTION){
            addWebViewforDoc()
        }else if(questionType == StringConstants.LIKART_SCALE_TYPE_QUESTION){
            addSliderView()
        }
    }
    
    func addRadioViews(){
        var y:Int = 130
        var button: SSRadioButton!
        radioButtonController = SSRadioButtonsController()
        for var i in (0..<options.count).reversed(){
            let option = options[i] as! [String: Any]
            let title = option["title"] as! String
            button = SSRadioButton(type: .system)
            button.frame = CGRect(x:100,y:y,width:100,height:30)
            y = y + 40
            button.circleRadius = CGFloat(10)
            button.circleColor = UIColor.black
            button.setTitle(title, for: .normal)
            button.tintColor = UIColor.darkGray
            view.addSubview(button)
            radioButtonController?.addButton(button)
            radioButtonController?.delegate = self
            radioButtonController?.shouldLetDeSelect = true
        }
    }
    
    func addCheckboxViews(){
        var y:Int = 130
        var button: CheckBox!
        for var i in (0..<options.count).reversed(){
            let option = options[i] as! [String: Any]
            let title = option["title"] as! String
            button = CheckBox(type: .system)
            button.awakeFromNib()
            button.tintColor = UIColor.darkGray
            button.titleEdgeInsets.left = 30
            button.frame = CGRect(x:100,y:y,width:100,height:30)
            y = y + 40
            button.setTitle(title, for: .normal)
            view.addSubview(button)
        }
    }
    
    func addTextView(){
        var y:Int = 130
        var textView: UITextView = UITextView.init()
        textView.frame = CGRect(x:30,y:y,width:300,height:128)
        textView.textAlignment = NSTextAlignment.justified
        //textView.backgroundColor = UIColor.lightGray
        let borderColor = UIColor.lightGray
        textView.layer.borderColor = borderColor.cgColor
        textView.layer.borderWidth = 1.0
        view.addSubview(textView)
    }
    
    func addSwitchView(){
        var y:Int = 130
        var switcher: UISwitch = UISwitch.init()
        switcher.frame = CGRect(x:30,y:y,width:300,height:128)
        view.addSubview(switcher)
    }
    
    func addWebView(){
        var y:Int = 130
        var webView: UIWebView = UIWebView.init()
        webView.frame = CGRect(x:16,y:y,width:350,height:600)
        let questionDetail = questionJson["detail"] as! String
        webView.loadHTMLString(questionDetail, baseURL: nil)
        view.addSubview(webView)
    }
    
    func addWebViewforDoc(){
        let webView = UIWebView(frame: self.view.frame)
        webView.scalesPageToFit = true
        view.addSubview(webView)
        let questionDetail = questionJson["detail"] as! String
        let urlS = StringConstants.DOC_URL + questionDetail
        let url = URL(string: urlS)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    func addSliderView(){
        let slider = UISlider(frame: self.view.frame)
        view.addSubview(slider)
        slider.minimumValue = 0
        slider.maximumValue = Float(options.count)
        slider.addTarget(self, action:#selector(sliderValueChanged), for: .valueChanged)
    }
    
    func sliderValueChanged(sender: UISlider) {
        //let value = options[Int(sender.value)]
        //sender.value = value
        // Do something else with the value
    }
    
    func submit(sender: UIButton){
        let questionSeq = sender.tag
        
    }

}

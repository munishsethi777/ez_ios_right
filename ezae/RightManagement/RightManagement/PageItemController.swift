//
//  PageItemController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 08/12/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit
import CoreData
class PageItemController: UIViewController, SSRadioButtonControllerDelegate{
    func didSelectButton(selectedButton: UIButton?) {
    }
    var radioButtonController: SSRadioButtonsController?
   
    
    @IBOutlet weak var feebackErrorLabel: UILabel!
    @IBOutlet weak var feedbackSuccessLabel: UILabel!
    @IBOutlet weak var submitProgress: UIButton!
    @IBOutlet weak var quesTitle: UILabel!
    var itemIndex: Int = 0 // ***
    var questionTitleText: String = ""
    var moduleJson: [String: Any] = [:]
    var questionJson: [String: Any] = [:]
    var imageName: String = ""
    var moduleType:String =  ""
    var questionType: String = ""
    var options: [Any] = []
    var pageNo: Int = 0
    var parentController: LaunchModuleViewController!
    var loggedInUserSeq:Int = 0
    var loggedInCompanySeq: Int = 0
    var totalQuestion: Int = 0
    var selectedAnsSeqs:[Int] = []
    var longQuestionTextView:UITextView!
    var switcher: UISwitch!
    var activityData:[String: Any] = [:]
    var moduleProgress:[Any]!
    var isProgressExist = false
    var isActivitySaved:Bool = false
    var feedback_success_arr:[String]!
    var feedback_error_arr:[String]!
    @IBAction func submitProgressAction(_ sender: UIButton) {
        submit(sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedAnsSeqs = []
        feedback_success_arr = []
        feedback_error_arr = []
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq();
        loggedInCompanySeq = PreferencesUtil.sharedInstance.getLoggedInCompanySeq();
        let questionTitle = questionJson["title"] as! String
        quesTitle.text = String(pageNo) + ". " + questionTitle
        questionType = questionJson["type"] as! String;
        options = questionJson["answers"] as! [Any];
        moduleType = moduleJson["moduletype"] as! String
        moduleProgress = questionJson["progress"] as! [Any]
        if(!moduleProgress.isEmpty){
            isProgressExist = true
        }
        handleWithExistingProgress()
        let allQuestions = moduleJson["questions"] as! [Any]
        
        totalQuestion = allQuestions.count
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
        executeSaveActivityCall()
        if(!moduleProgress.isEmpty){
            handleViews()
        }
    }
    
    func handleWithExistingProgress(){
        let questionSeq = Int(questionJson["seq"] as! String)!
        let moduleSeq = Int(questionJson["moduleSeq"] as! String)!
        let learningPlanseq = Int(questionJson["learningPlanSeq"] as! String)!
        let existingProgress = ModuleProgressMgr.sharedInstance.getExistingProgressArray(questionSeq: questionSeq, moduleSeq: moduleSeq, learningPlanSeq: learningPlanseq)
        moduleProgress = existingProgress + moduleProgress
        if(moduleProgress.count != 0){
            submitProgress.isEnabled = false
        }else{
            submitProgress.isEnabled = true
        }
    }
    
    func addRadioViews(){
        var y:Int = 130
        var button: SSRadioButton!
        radioButtonController = SSRadioButtonsController()
        var existingAnswerSeq:String = ""
        if(!moduleProgress.isEmpty){
            let existingProgress = moduleProgress[0] as? [String: Any]
            existingAnswerSeq = existingProgress?["answerSeq"] as! String
            selectedAnsSeqs.append(Int(existingAnswerSeq)!)
        }
        for var i in (0..<options.count).reversed(){
            let option = options[i] as! [String: Any]
            let title = option["title"] as! String
            let seq = option["seq"] as! String
            button = SSRadioButton(type: .system)
            button.frame = CGRect(x:100,y:y,width:100,height:30)
            y = y + 40
            button.circleRadius = CGFloat(10)
            button.circleColor = UIColor.black
            button.setTitle(title, for: .normal)
            button.tintColor = UIColor.darkGray
            button.tag = Int(seq)!
            button.addTarget(self, action:#selector(addSelectedAnsSeq), for: .touchUpInside)
            if(seq == existingAnswerSeq){
                button.isSelected = true
            }
            view.addSubview(button)
            radioButtonController?.addButton(button)
            radioButtonController?.delegate = self
            radioButtonController?.shouldLetDeSelect = true
        }
        if(!moduleProgress.isEmpty){
            getScoreForSelectedOption()
        }
    }
    
    func addCheckboxViews(){
        var y:Int = 130
        var button: CheckBox!
        for var i in (0..<options.count).reversed(){
            let option = options[i] as! [String: Any]
            let title = option["title"] as! String
            let seq = option["seq"] as! String
            button = CheckBox(type: .system)
            button.awakeFromNib()
            button.tintColor = UIColor.darkGray
            button.titleEdgeInsets.left = 30
            button.tag = Int(seq)!
            button.frame = CGRect(x:100,y:y,width:100,height:30)
            let isChecked = isOptionSeqExistsInAnwers(optionSeq: seq)
            if(isChecked){
                selectedAnsSeqs.append(Int(seq)!)
            }
            button.isChecked = isChecked
            y = y + 40
            button.setTitle(title, for: .normal)
            button.addTarget(self, action:#selector(addMultiSelectedAnsSeq), for: .touchUpInside)
            view.addSubview(button)
        }
        if(!moduleProgress.isEmpty){
            getScoreForSelectedOption()
        }
    }
    
    func addTextView(){
        var answerText:String = ""
        if(!moduleProgress.isEmpty){
            let existingProgress = moduleProgress[0] as? [String: Any]
            answerText = (existingProgress?["answerText"] as? String)!
            feedback_success_arr.append(StringConstants.SUBMITTED_SUCCESSFULLY)
        }
        let y:Int = 130
        longQuestionTextView = UITextView.init()
        longQuestionTextView.frame = CGRect(x:30,y:y,width:300,height:128)
        longQuestionTextView.textAlignment = NSTextAlignment.justified
        let borderColor = UIColor.lightGray
        longQuestionTextView.layer.borderColor = borderColor.cgColor
        longQuestionTextView.layer.borderWidth = 1.0
        longQuestionTextView.text = answerText
        view.addSubview(longQuestionTextView)
        if(!moduleProgress.isEmpty){
            getScoreForSelectedOption()
        }
    }
    
    func addSwitchView(){
        let y:Int = 130
        switcher = UISwitch.init()
        switcher.frame = CGRect(x:30,y:y,width:300,height:128)
        changeSwitcher(sender: switcher)
        if(!moduleProgress.isEmpty){
            let existingProgress = moduleProgress[0] as? [String: Any]
            let answerSeq = existingProgress?["answerSeq"] as! String
            let selectedAnsBySeq = getAnswerBySeq(ansSeq: Int(answerSeq)!)
            let ansTitle = selectedAnsBySeq!["title"] as! String
            if(ansTitle == "no"){
                switcher.isOn = false
            }else{
                switcher.isOn = true
            }
            selectedAnsSeqs.append(Int(answerSeq)!)
        }
        switcher.addTarget(self, action:#selector(changeSwitcher), for: .valueChanged)
        view.addSubview(switcher)
        if(!moduleProgress.isEmpty){
            getScoreForSelectedOption()
        }
    }
    
    func changeSwitcher(sender: UISwitch){
        var ansTitle = "no"
        if(sender.isOn){
            ansTitle = "yes"
        }
        let selectedAns = getAnswerByTitle(ansTitle: ansTitle)
        let seq = selectedAns!["seq"] as! String
        selectedAnsSeqs = []
        selectedAnsSeqs.append(Int(seq)!)
    }
    
    func addWebView(){
        let y:Int = 130
        let webView: UIWebView = UIWebView.init()
        webView.frame = CGRect(x:16,y:y,width:350,height:300)
        let questionDetail = questionJson["detail"] as! String
        webView.loadHTMLString(questionDetail, baseURL: nil)
        view.addSubview(webView)
    }

    func addWebViewforDoc(){
        let webView = UIWebView(frame: CGRect(x:16,y:130,width:350,height:300))
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
    
    func addSelectedAnsSeq(sender: UIButton){
        let selectedAnsSeq = sender.tag
        selectedAnsSeqs = []
        selectedAnsSeqs.append(selectedAnsSeq)
    }
    
    func addMultiSelectedAnsSeq(sender: CheckBox){
        let selectedAnsSeq = sender.tag
        if(sender.isChecked){
            selectedAnsSeqs.append(selectedAnsSeq)
        }else{
            if let index = selectedAnsSeqs.index(of: selectedAnsSeq) {
                selectedAnsSeqs.remove(at: index)
            }
        }
    }
    
    func sliderValueChanged(sender: UISlider) {
        //let value = options[Int(sender.value)]
        //sender.value = value
        // Do something else with the value
    }
    
    func submit(sender: UIButton){
        var answerText = ""
        var scores:[Int: Double] = [:]
        if(moduleType == StringConstants.LESSION_TYPE_MODULE){
            ModuleProgressMgr.sharedInstance.saveModuleProgress(response: questionJson, answerText:answerText, score: 0, startDate: Date.init(), isTimeUp: false)
        }else if(questionType == StringConstants.LONG_TYPE_QUESTION){
            feedback_success_arr.append(StringConstants.SUBMITTED_SUCCESSFULLY)
            answerText = longQuestionTextView.text
            let score = questionJson["maxMarks"] as! String;
            ModuleProgressMgr.sharedInstance.saveModuleProgress(response: questionJson, answerText:answerText, score: Double(score)!, startDate: Date.init(), isTimeUp: false)
        }else{
            scores = getScoreForSelectedOption()
            ModuleProgressMgr.sharedInstance.saveModuleProgress(response: questionJson, ansSeqs: selectedAnsSeqs, scores: scores, startDate: Date.init())
        }
        self.handleViews()
        if(itemIndex + 1 == totalQuestion){
            executeSubmitModuleCall()
        }
        parentController.createPageViewController(itemIndex: itemIndex)
    }
    
    func executeSubmitModuleCall(){
        let moduleSeq = Int(questionJson["moduleSeq"] as! String)!;
        let learningPlanSeq = Int(questionJson["learningPlanSeq"] as! String)!;
        var jsonString = ModuleProgressMgr.sharedInstance.getExistingProgressJosnStringForModule(moduleSeq: moduleSeq, learningPlanSeq: learningPlanSeq)
        jsonString = jsonString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let args: [Any] = [self.loggedInUserSeq,self.loggedInCompanySeq,jsonString]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.SUBMIT_MODULE_PROGRESS, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        ModuleProgressMgr.sharedInstance.deleteModuleProgress(moduleSeq: moduleSeq, learningPlanSeq: learningPlanSeq)
                        self.performSegue(withIdentifier: "showTrainingView", sender: self)
                        self.showAlert(message: message!)
                    }
                }
            } catch let parseError as NSError {
                self.showAlert(message: parseError.description)
            }
        })
    }
    
    func executeSaveActivityCall(){
        if(!isProgressExist && itemIndex == 0 && !isActivitySaved){
            let randomQuestionKeys:[String: Any] = [:]
            let moduleSeq = Int(questionJson["moduleSeq"] as! String)!;
            let learningPlanSeq = Int(questionJson["learningPlanSeq"] as! String)!;
            var jsonString = ModuleProgressMgr.sharedInstance.getActivityJsonString(moduleSeq: moduleSeq, learningPlanSeq: learningPlanSeq,randomQuesitionKeys: randomQuestionKeys)
            jsonString = jsonString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let args: [Any] = [self.loggedInUserSeq,self.loggedInCompanySeq,jsonString]
            let apiUrl: String = MessageFormat.format(pattern: StringConstants.SAVE_ACTIVITY, args: args)
            var success : Int = 0
            var message : String? = nil
            ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                    success = json["success"] as! Int
                    message = json["message"] as? String
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if(success == 1){
                            self.isActivitySaved = true
                        }
                    }
                } catch let parseError as NSError {
                    self.showAlert(message: parseError.description)
                }
            })
        }
    }
    
    func getScoreForSelectedOption()->[Int:Double]{
        var scores:[Int:Double] = [:];
        for selectedAns in selectedAnsSeqs{
            let selectedAns = getAnswerBySeq(ansSeq: selectedAns)
            let scoreStr = selectedAns!["marks"] as! String
            let seq = selectedAns!["seq"] as! String
            var score:Double = 0
            if(!scoreStr.isEmpty){
                score = Double(scoreStr)!
                scores[Int(seq)!] = score
            }
            var feedback = selectedAns!["feedback"] as? String;
            if(moduleType == "quiz") {
                if (score > 0) {
                    if (feedback == nil || feedback != "null") {
                        feedback = "Correct";
                    }
                    feedback_success_arr.append(feedback!);
                } else {
                    if (feedback == nil || feedback != "null") {
                        feedback = "Incorrect";
                    }
                    feedback_error_arr.append(feedback!);
                }
            }else{
                feedback_success_arr.append("Submitted");
            }
        }
        return scores
    }
    
    func getAnswerBySeq(ansSeq:Int)->[String: Any]?{
        for var i in (0..<options.count).reversed(){
            let option = options[i] as! [String: Any]
            let optionSeq = option["seq"] as! String
            if(String(ansSeq) == optionSeq){
                return option
            }
        }
        return nil
    }
    func getAnswerByTitle(ansTitle:String)->[String: Any]?{
        for var i in (0..<options.count).reversed(){
            let option = options[i] as! [String: Any]
            let title = option["title"] as! String
            if(title == ansTitle){
                return option
            }
        }
        return nil
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "API Exception", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func toString(jsonObject:[Any])->String{
        let jsonString: String!
        do {
            let postData : NSData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            jsonString = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            jsonString = ""
        }
        return jsonString!
    }
    
    private func isOptionSeqExistsInAnwers(optionSeq: String)->Bool{
        var flag:Bool = false
        for var i in (0..<moduleProgress.count).reversed(){
            let existingProgress = moduleProgress[i] as? [String: Any]
            let existingAnswerSeq = existingProgress?["answerSeq"] as! String
            if(existingAnswerSeq == optionSeq ){
                flag = true
                break
            }
        }
        return flag
    }
    private func isOptionTitleExistsInAnwers(optionSeq: String)->Bool{
        var flag:Bool = false
        for var i in (0..<moduleProgress.count).reversed(){
            let existingProgress = moduleProgress[i] as? [String: Any]
            let existingAnswerSeq = existingProgress?["answerSeq"] as! String
            if(existingAnswerSeq == optionSeq ){
                flag = true
                break
            }
        }
        return flag
    }
    
    private func handleViews(){
        submitProgress.isEnabled = false
        showFeedback()
    }
    
    private func showFeedback(){
        let isShowFeedback = moduleJson["isshowfeedback"] as! String
        if(Int(isShowFeedback)! > 0){
            var successText:String = "";
            for feedback in feedback_success_arr {
                successText += feedback + "\n"
            }
            var errorText:String = "";
            for feedback in feedback_error_arr {
                errorText += feedback + "\n"
            }
            if(!successText.isEmpty){
                successText.removeLast()
                feedbackSuccessLabel.isHidden = false
                feedbackSuccessLabel.text = successText
            }
            if(!errorText.isEmpty){
                errorText.removeLast()
                feebackErrorLabel.isHidden = false
                feebackErrorLabel.text = errorText
            }
        }
    }

}
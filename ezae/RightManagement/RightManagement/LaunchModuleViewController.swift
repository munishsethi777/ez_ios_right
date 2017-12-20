//
//  DynamicViewController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 01/12/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//
import UIKit
class LaunchModuleViewController: UIViewController,UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    var loggedInUserSeq: Int = 0
    var loggedInCompanySeq: Int = 0
    @IBOutlet weak var moduleTitle: UILabel!
    @IBOutlet weak var pageNoLabel: UILabel!
    @IBOutlet weak var marksLabel: UILabel!
    
    var moduleSeq: Int = 0
    var lpSeq: Int = 0
    var jsonResponse: [String: Any] = [:]
    var questionJsonArr: [Any] = []
    var moduleJson: [String: Any] = [:]
    var isNext:Bool = false;
    var activityData:[String: Any] = [:]
    var currentQuestion:[String: Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loggedInUserSeq =  PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        self.loggedInCompanySeq =  PreferencesUtil.sharedInstance.getLoggedInCompanySeq()
        getModuleDetail()
        setupPageControl()
        // Do any additional setup after loading the view, typically from a nib.
    }
    var pageViewController: UIPageViewController?
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func createPageViewController(itemIndex:Int) {
        moduleJson = jsonResponse["module"] as! [String: Any]
        if let activity = moduleJson["activity"] {
            self.activityData = activity as! [String: Any]
        }
        questionJsonArr = moduleJson["questions"] as! [Any]
        moduleTitle.text = moduleJson["title"] as! String
        let pageController = self.storyboard!.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if questionJsonArr.count > 0 {
            setPaggerLabel(page: itemIndex+1)
            let firstController = getItemController(itemIndex: itemIndex)!
            let startingViewControllers = [firstController]
            pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        pageController.delegate = self
        pageViewController = pageController
        addChildViewController(pageViewController!)
        let childView:UIView = pageViewController!.view
        childView.frame = CGRect(x: 0, y: 130, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-20);
        self.view.addSubview(childView)
        pageViewController!.didMove(toParentViewController: self)
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
    }
    
    private func getQuesProgress(itemIndex: Int)->[Any]{
        let questionJson = questionJsonArr[itemIndex] as! [String: Any]
        let questionSeq = Int(questionJson["seq"] as! String)!
        let moduleSeq = Int(questionJson["moduleSeq"] as! String)!
        let learningPlanseq = Int(questionJson["learningPlanSeq"] as! String)!
        let localProgress = ModuleProgressMgr.sharedInstance.getExistingProgressArray(questionSeq: questionSeq, moduleSeq: moduleSeq, learningPlanSeq: learningPlanseq)
        var moduleProgress = questionJson["progress"] as! [Any]
        moduleProgress = localProgress + moduleProgress
        return moduleProgress
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! PageItemController
        if itemController.itemIndex+1 < questionJsonArr.count {
            isNext = true;
            return getItemController(itemIndex: itemController.itemIndex+1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! PageItemController
        if itemController.itemIndex > 0 {
            isNext = false
            return getItemController(itemIndex: itemController.itemIndex-1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]){
        let itemController = pendingViewControllers[0] as! PageItemController
        var count = itemController.pageNo
        setPaggerLabel(page: count)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool){
        
    }
    
    
    func setPaggerLabel(page: Int){
        let questionJson = moduleJson["questions"] as! [Any]
        let totalQuesCount = questionJson.count
        var countStr = " Pages"
        let moduleType = moduleJson["moduletype"] as! String
        if(moduleType == "quiz"){
            countStr = " Questions"
        }
        pageNoLabel.text = String(page) + " of " + String(totalQuesCount) + countStr
    }
    
    private func getItemController(itemIndex: Int) -> PageItemController? {
        if itemIndex < questionJsonArr.count {
            if(itemIndex > 0){
                let progress = getQuesProgress(itemIndex: itemIndex-1)
                if(progress.isEmpty){
                    return nil
                }
            }
            let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "ItemController") as! PageItemController
            pageItemController.moduleJson = moduleJson
            pageItemController.activityData = activityData
            pageItemController.itemIndex = itemIndex
            let pageNo = itemIndex + 1
            pageItemController.parentController = self
            pageItemController.pageNo = pageNo
            pageItemController.questionJson = questionJsonArr[itemIndex] as! [String: Any]
            let questionJson = moduleJson["questions"] as! [Any]
            let question = questionJson[itemIndex] as! [String: Any]
            var marks = question["marks"] as? String
            if(marks == nil){
                marks = "0"
            }
            marksLabel.text = "Marks:" + marks!
            return pageItemController
        }
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return questionJsonArr.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func getModuleDetail(){
        let args: [Int] = [self.loggedInUserSeq,self.moduleSeq,self.lpSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_MODULE_DETAIL, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.jsonResponse = json
                        self.createPageViewController(itemIndex:0)
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
}
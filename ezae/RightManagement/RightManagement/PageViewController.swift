//
//  PageViewController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 01/12/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController
{

    var currentPage: Int = 0;
    fileprivate lazy var pages: [UIViewController] = {
        let label: UILabel
        let controller = DynamicViewController()
        controller.strings = ["Hello world", "Foobar", "Baz"]
        
        let controller1 = DynamicViewController()
        controller1.strings = ["Hellos world", "Fosobar", "Basz"]
        
        return [
            controller,
            controller1,
            self.getViewController(withIdentifier: "Page1"),
            self.getViewController(withIdentifier: "Page2")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.dataSource = nil
        self.delegate   = nil
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func goToNext(){
        if(currentPage < pages.count){
            currentPage = currentPage + 1
        }
        let currentController = pages[currentPage]
        setViewControllers([currentController], direction: .forward, animated: true, completion: nil)
    }
    func goToPrevious(){
        if(currentPage > 1){
            currentPage = currentPage - 1
        }
        let currentController = pages[currentPage]
        setViewControllers([currentController], direction: .forward, animated: true, completion: nil)
    }
}

extension PageViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return pages.last }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil         }
        
        return pages[nextIndex]
    }
}

extension PageViewController: UIPageViewControllerDelegate { }



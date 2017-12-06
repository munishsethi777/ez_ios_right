//
//  DynamicViewController.swift
//  RightManagement
//
//  Created by Baljeet Gaheer on 01/12/17.
//  Copyright © 2017 Munish Sethi. All rights reserved.
//

import UIKit
class DynamicViewController: UIViewController {
    
    var strings: [String]!
    
    override func loadView() {
        // super.loadView()   // DO NOT CALL SUPER
        
        view = UIView()
        view.backgroundColor = .lightGray
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        for string in strings {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = string
            stackView.addArrangedSubview(label)
        }
        
        let btn = UIButton()
        btn.setTitle("Next",for: .normal)
        btn.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        stackView.addArrangedSubview(btn)
    }
    
    func buttonClicked(){
        let parentController = self.parent as! PageViewController
        parentController.goToNext()
    }
}

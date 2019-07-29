//
//  RedContentsViewController.swift
//  SlideMenu_storyboard
//
//  Created by 豊岡正紘 on 2019/07/29.
//  Copyright © 2019 Masahiro Toyooka. All rights reserved.
//

import Foundation
import UIKit

class RedContentsViewController: UIViewController {
    
    private var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        var titleTextAttributes = [NSAttributedString.Key: Any]()
        titleTextAttributes[NSAttributedString.Key.font]            = UIFont(name: "HiraKakuProN-W3", size: 14.0)
        titleTextAttributes[NSAttributedString.Key.foregroundColor] = UIColor.black
        
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        self.navigationItem.title = "RED"
        
        
        var menuAttributes = [NSAttributedString.Key : Any]()
        menuAttributes[NSAttributedString.Key.font]            = UIFont(name: "HiraKakuProN-W3", size: 30)
        menuAttributes[NSAttributedString.Key.foregroundColor] = UIColor.gray
        menuButton = UIBarButtonItem(title: "≡", style: .plain, target: self, action: #selector(menuButtonTapped(_:)))
        menuButton.setTitleTextAttributes(menuAttributes, for: .normal)
        navigationItem.leftBarButtonItem = menuButton
    }
    
    @objc func menuButtonTapped(_ sender: UIBarButtonItem) {
        
        if let parentViewController = self.parent?.parent {
            let vc = parentViewController as! BaseViewController
            vc.openSideNavigation()
        }
    }
}

//
//  ViewController.swift
//  SlideMenu_storyboard
//
//  Created by 豊岡正紘 on 2019/07/26.
//  Copyright © 2019 Masahiro Toyooka. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    

    private var selectedButtonType: Int = SlideNavigationButtonType.redContents.rawValue
    
    
    @IBOutlet weak var sideNavigationContainer: UIView!
    
    @IBOutlet weak var mainContentsContainer: UIView!
    
    @IBOutlet weak var wrapperButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension BaseViewController: SlideNavigationButtonDelegate {
    
    func changeMainContentsController(_ buttonType: Int) {
        
        let isCurrentDisplay = (selectedButtonType == buttonType)
        
        switch buttonType {
        case SlideNavigationButtonType.redContents.rawValue:
            selectedButtonType = buttonType
          
        case SlideNavigationButtonType.blueContents.rawValue:
            selectedButtonType = buttonType
        default:
            break
        }
    }
}


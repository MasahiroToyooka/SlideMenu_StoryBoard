//
//  SlideNavigationController.swift
//  SlideMenu_storyboard
//
//  Created by 豊岡正紘 on 2019/07/26.
//  Copyright © 2019 Masahiro Toyooka. All rights reserved.
//

import Foundation
import UIKit

protocol SlideNavigationButtonDelegate: NSObjectProtocol{
    func changeMainContentsController(_ buttonType: Int)
}

class SlideNavigationController: UIViewController {
    
    weak var delegate: SlideNavigationButtonDelegate?
    
    @IBOutlet weak var redContantsButton: UIButton!
    @IBOutlet weak var blueContantsButton: UIButton!
    @IBOutlet weak var yellowContentsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redContantsButton.tag = SlideNavigationButtonType.redContents.rawValue
        redContantsButton.addTarget(self, action: #selector(slideNavigationButtonTapped), for: .touchUpInside)
        
        blueContantsButton.tag = SlideNavigationButtonType.blueContents.rawValue
        blueContantsButton.addTarget(self, action: #selector(slideNavigationButtonTapped), for: .touchUpInside)
        
        yellowContentsButton.tag = SlideNavigationButtonType.yellowContents.rawValue
        yellowContentsButton.addTarget(self, action: #selector(slideNavigationButtonTapped), for: .touchUpInside)
    }
    
    @objc func  slideNavigationButtonTapped(sender: UIButton) {
        let selectedButtonType = sender.tag
        self.delegate?.changeMainContentsController(selectedButtonType)
    }
}

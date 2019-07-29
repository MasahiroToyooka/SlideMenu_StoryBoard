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
    private var sideNavigationStatus: SideNavigationStatus = .closed
    private var touchBeganPositionX: CGFloat!
    
    
    @IBOutlet weak var sideNavigationContainer: UIView!
    
    @IBOutlet weak var mainContentsContainer: UIView!
    
    @IBOutlet weak var wrapperButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayRedContentsViewController()
        
        wrapperButton.backgroundColor = .black
        wrapperButton.alpha = 0.0
        wrapperButton.isUserInteractionEnabled = false
        
        
        let leftEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeTapGesture))
        leftEdgeGesture.edges = .left
        mainContentsContainer.addGestureRecognizer(leftEdgeGesture)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "connectSideNavigationContainer" {
            let slideNavigationController = segue.destination as! SlideNavigationController
            slideNavigationController.delegate = self
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touchEvent = touches.first!
        
        let beginPosition = touchEvent.previousLocation(in: self.view)
        touchBeganPositionX = beginPosition.x
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if sideNavigationStatus == .opened && touchBeganPositionX >= 260 {
            
            sideNavigationContainer.isUserInteractionEnabled = false
            mainContentsContainer.isUserInteractionEnabled = false
            
            let touchEvent = touches.first!
            
            let preDx = touchEvent.previousLocation(in: self.view).x
            let newDx = touchEvent.location(in: self.view).x
            
            let dx = newDx - preDx
            
            var viewFrame: CGRect = wrapperButton.frame
            viewFrame.origin.x += dx
            mainContentsContainer.frame = viewFrame
            wrapperButton.frame = viewFrame
            
            if mainContentsContainer.frame.origin.x > 260 {
                
                mainContentsContainer.frame.origin.x = 260
                wrapperButton.frame.origin.x = 260
            } else if mainContentsContainer.frame.origin.x < 0 {
                mainContentsContainer.frame.origin.x = 0
                wrapperButton.frame.origin.x         = 0
            }
            
            sideNavigationContainer.alpha = mainContentsContainer.frame.origin.x / 260
            wrapperButton.alpha = mainContentsContainer.frame.origin.x / 260 * 0.36
         }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if touchBeganPositionX >= 260 && (mainContentsContainer.frame.origin.x == 260 || mainContentsContainer.frame.origin.x < 160) {
            changeContainerSettingWithAnimation(.closed)
        } else if touchBeganPositionX >= 260 && mainContentsContainer.frame.origin.x >= 160 {
            changeContainerSettingWithAnimation(.opened)
        }
    }
    
    //MARK: - Function
    
    func openSideNavigation() {
        changeContainerSettingWithAnimation(.opened)
    }

    @objc func edgeTapGesture(gesture: UIScreenEdgePanGestureRecognizer) {
        sideNavigationContainer.isUserInteractionEnabled = false
        mainContentsContainer.isUserInteractionEnabled = false
        
        let move: CGPoint = gesture.translation(in: mainContentsContainer)
        
        wrapperButton.frame.origin.x += move.x
        mainContentsContainer.frame.origin.x += move.x
        
        sideNavigationContainer.alpha = mainContentsContainer.frame.origin.x / 260
        wrapperButton.alpha           = mainContentsContainer.frame.origin.x / 260 * 0.36

        
        if mainContentsContainer.frame.origin.x > 260 {
            mainContentsContainer.frame.origin.x = 260
            wrapperButton.frame.origin.x = 260
        } else if mainContentsContainer.frame.origin.x < 0 {
            mainContentsContainer.frame.origin.x = 0
            wrapperButton.frame.origin.x = 0
        }
        
        if gesture.state == .ended {
            if mainContentsContainer.frame.origin.x < 160 {
                changeContainerSettingWithAnimation(.closed)
            } else {
                changeContainerSettingWithAnimation(.opened)
            }
        }
        gesture.setTranslation(CGPoint.zero, in: self.view)
    }

    private func changeContainerSettingWithAnimation(_ status: SideNavigationStatus) {
        if status == .opened {
            sideNavigationStatus = status
            executeSideOpenAnimation()
        } else {
            sideNavigationStatus = .closed
            executeSideCloseAnimation()
        }
    }
    
    
    private func executeSideOpenAnimation(withCompletion: (() -> ())? = nil) {
        self.sideNavigationContainer.isUserInteractionEnabled = true
        self.mainContentsContainer.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.16, delay: 0, options: .curveEaseOut, animations: {
            
            self.mainContentsContainer.frame = CGRect(x: 260, y: self.mainContentsContainer.frame.origin.y, width: self.mainContentsContainer.frame.width
                , height: self.mainContentsContainer.frame.height)
            
            self.wrapperButton.frame = CGRect(x: 260, y: self.wrapperButton.frame.origin.y, width: self.wrapperButton.frame.width, height: self.wrapperButton.frame.height)
            
            self.sideNavigationContainer.alpha = 1
            self.wrapperButton.alpha = 0.36
        }, completion: { (_) in
            withCompletion?()
        })
    }
    
    private func executeSideCloseAnimation(withCompletion: (() -> ())? = nil) {
        self.sideNavigationContainer.isUserInteractionEnabled = false
        self.mainContentsContainer.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.16, delay: 0, options: .curveEaseOut, animations: {
            self.mainContentsContainer.frame = CGRect(x: 0, y: self.mainContentsContainer.frame.origin.y, width: self.mainContentsContainer.frame.width, height: self.mainContentsContainer.frame.height)
            
            self.wrapperButton.frame = CGRect(x: 0, y: self.wrapperButton.frame.origin.y, width: self.wrapperButton.frame.width, height: self.wrapperButton.frame.height)
            
            self.sideNavigationContainer.alpha = 0
            self.wrapperButton.alpha = 0
        }, completion: { (_) in
            withCompletion?()
        })
    }
    
    private func displayRedContentsViewController() {
        if let vc = UIStoryboard(name: "RedContents", bundle: nil).instantiateInitialViewController() {
            mainContentsContainer.addSubview(vc.view)
            self.addChild(vc)
            vc.didMove(toParent: self)
        }
    }
    
    private func displayYellowContentsViewController() {
        if let vc = UIStoryboard(name: "YellowContents", bundle: nil).instantiateInitialViewController() {
            mainContentsContainer.addSubview(vc.view)
            self.addChild(vc)
            vc.didMove(toParent: self)
        }
    }
    
    private func displayBlueContentsViewController() {
        if let vc = UIStoryboard(name: "BlueContents", bundle: nil).instantiateInitialViewController() {
            mainContentsContainer.addSubview(vc.view)
            self.addChild(vc)
            vc.didMove(toParent: self)
        }
    }
}

extension BaseViewController: SlideNavigationButtonDelegate {
    
    func changeMainContentsController(_ buttonType: Int) {
        
        let isCurrentDisplay = (selectedButtonType == buttonType)
        
        switch buttonType {
        case SlideNavigationButtonType.redContents.rawValue:
            selectedButtonType = buttonType
            executeSideCloseAnimation {
                if !isCurrentDisplay {
                    self.displayRedContentsViewController()
                }
            }
        case SlideNavigationButtonType.yellowContents.rawValue:
            selectedButtonType = buttonType
            executeSideCloseAnimation {
                if !isCurrentDisplay {
                    self.displayYellowContentsViewController()
                }
            }
        case SlideNavigationButtonType.blueContents.rawValue:
            selectedButtonType = buttonType
            executeSideCloseAnimation {
                if !isCurrentDisplay {
                    self.displayBlueContentsViewController()
                }
            }
        default:
            break
        }
    }
}


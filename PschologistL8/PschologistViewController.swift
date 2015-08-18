//
//  ViewController.swift
//  Pschologist
//
//  Created by iMac21.5 on 4/18/15.
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//

import UIKit

class PschologistViewController: UIViewController {
    
    func logVCL(message: String) {
            println(message)
    }
    
    @IBAction func nothing(sender: UIButton) {
        performSegueWithIdentifier("nothing", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        if let hvc = destination as? HappinessViewController {
            if let identifier = segue.identifier {
                switch identifier {
                    case "sad": hvc.happiness = 0
                    case "happy": hvc.happiness = 100
                    case "nothing": hvc.happiness = 25  //added above for code decision segues
                    default: hvc.happiness = 50
                }
            }
        }
    }

    override func awakeFromNib() {
        logVCL("awakeFromNib()")
    }
    
    override func viewDidLoad() {
        logVCL("viewDidLoad()")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logVCL("viewWillAppear(animated = \(animated))")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        logVCL("viewDidAppear(animated = \(animated))")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        logVCL("viewWillDisappear(animated = \(animated))")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        logVCL("viewDidDisappear(animated = \(animated))")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logVCL("viewWillLayoutSubviews() (view.bounds.size = \(view.bounds.size))")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logVCL("viewDidLayoutSubviews() (view.bounds.size = \(view.bounds.size))")
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        logVCL("viewWillTransitionToSize(size, withTransitionCoordinator: coordinator) = \(size))")
        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.logVCL("coordinator.animateAlongsideTransition")
        }, completion: { context -> Void in
            self.logVCL("coordinator.animateAlongsideTransition-Complete")
        })
    }
    
}
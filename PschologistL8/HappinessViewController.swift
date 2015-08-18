//
//  HappinessViewController.swift
//  Happiness
//
//  Created by iMac21.5 on 4/15/15.
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
        }
    }
    
    private struct Constants {
        static let HappinessGestureScale: CGFloat = 4
    }
    // note: uses Action instead of Outlet (see below) pannableView
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default: break
        }
    }
    
    var happiness: Int = 75 { // 0 is very sad, 100 is ecstatic
        didSet {
            happiness = min(max(happiness, 0), 100)
            println("happiness = \(happiness)")
            updateUI()
        }
    }
    
    func updateUI() {
        faceView?.setNeedsDisplay()
        title = "Diagnosis = \(happiness)% happy"
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness - 50)/50  //-1 to +1
    }
    
//    @IBOutlet weak var pannableView: UIView! {
//        didSet {
//            let recognizer = UIPanGestureRecognizer(target: self, action: "pan:")
//            pannableView.addGestureRecognizer(recognizer)
//        }
//    }
//    
//    func pan(gesture: UIPanGestureRecognizer) {
//        switch gesture.state {
//        case .Changed: fallthrough
//        case .Ended:
//            let translation = gesture.translationInView(pannableView)
//            // update any thing that depends on the pan gesture using translation.x and .y
//            gesture.setTranslation(CGPointZero, inView: pannableView) //use CGPointZero so get incremental distance between states
//        default: break
//        }
//    }
    
    @IBAction func winkLeft(sender: UIButton) {
        let eye = "L"
        let face = view.subviews.first as! FaceView
        face.wink(eye)
    }
    @IBAction func blink() {
        let face = view.subviews.first as! FaceView
        face.blink()
    }
    @IBAction func winkRight(sender: UIButton) {
        let eye = "R"
        let face = view.subviews.first as! FaceView
        face.wink(eye)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

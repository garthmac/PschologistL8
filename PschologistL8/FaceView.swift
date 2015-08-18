//
//  FaceView.swift
//  Happiness
//
//  Created by iMac21.5 on 4/15/15.
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//

import UIKit

protocol FaceViewDataSource: class {
    func smilinessForFaceView(sender: FaceView) -> Double?
}

@IBDesignable
class FaceView: UIView {

    var winkLeft: Bool = false { didSet { setNeedsDisplay() } }
    var winkRight: Bool = false { didSet { setNeedsDisplay() } }
    @IBInspectable var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    @IBInspectable var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    var faceCenter: CGPoint { return convertPoint(center, fromView: superview) }
    var faceRadius: CGFloat { return min(bounds.size.width, bounds.size.height) / 2 * scale }
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToEyeMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye { case Left, Right }
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath { // 1 is full smile, -1 is full frown
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    weak var dataSource: FaceViewDataSource?
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        color = UIColor.yellowColor()
        color.setFill()
        facePath.fill()
        if winkLeft {
            bezierPathForEye(.Left).fill()
        }
        if winkRight {
            bezierPathForEye(.Right).fill()
        }
        
        facePath.lineWidth = lineWidth
        color = UIColor.blueColor()
        color.set()
        facePath.stroke()
        if !winkLeft {
            bezierPathForEye(.Left).fill()
        }
        if !winkRight {
            bezierPathForEye(.Right).fill()
        }
        //shift-command-o for quick code view swap
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }
    
    func wink(anEye: String) -> Void {
        if anEye == "L" {
            winkLeft = true
        }
        if anEye == "R" {
            winkRight = true
        }
        return
    }
    
    func blink() -> Void {
        if !winkLeft && !winkRight {
            wink("L")
            wink("R")
            return
        }
        if winkLeft {
            winkLeft = false
        }
        if winkRight {
            winkRight = false
        }
        return
    }
    
}

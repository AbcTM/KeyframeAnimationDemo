//
//  CircularAnimationView.swift
//  AnimationDemo
//
//  Created by tm on 2019/10/10.
//  Copyright © 2019 tm. All rights reserved.
//

import UIKit

class CircularAnimationView: UIView {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        // 画出动画的路径
        if let context = UIGraphicsGetCurrentContext() {
            UIGraphicsPushContext(context)
            let animationPath = getCirCularAnimationPath()
            UIColor.red.setStroke()
            animationPath.lineWidth = 2.0
            animationPath.stroke()
            UIGraphicsPopContext()
        }
    }
 
    
    // MARK: -
    
    func biuCircular() {
        let newCirLayer = getCirCularLayer()
        newCirLayer.frame = CGRect(x: bounds.width, y: bounds.height*0.5-10, width: 20, height: 20)
        layer.addSublayer(newCirLayer)
        
        let cirAnimation = getCirCularAnimation()
        cirAnimation.delegate = self
        newCirLayer.add(cirAnimation, forKey: "cirAnimation")
    }

    // MARK: - private
    
    fileprivate func getCirCularLayer() -> CALayer {
        let layer = CALayer()
//        layer.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        layer.contents = UIImage(named: "yuan")?.cgImage
        layer.contentsGravity = CALayerContentsGravity.resizeAspect
        return layer
    }
    
    fileprivate func getCirCularAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation.init(keyPath: "position")
        animation.path = getCirCularAnimationPath().cgPath
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.fillMode = .forwards
        animation.duration = 3
        animation.isRemovedOnCompletion = true
        return animation
    }
    
    @discardableResult
    fileprivate func getCirCularAnimationPath() -> UIBezierPath {
        let animationPath = UIBezierPath()
        animationPath.move(to: CGPoint(x: bounds.width, y: bounds.height/2))
        animationPath.addLine(to: CGPoint(x: 0, y: bounds.height/2))
        return animationPath
    }
}

extension CircularAnimationView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let layer = layer.sublayers?.first {
            layer.removeFromSuperlayer()
        }
    }
}

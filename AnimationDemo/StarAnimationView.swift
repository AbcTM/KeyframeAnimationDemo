//
//  StarAnimationView.swift
//  AnimationDemo
//
//  Created by tm on 2019/10/10.
//  Copyright © 2019 tm. All rights reserved.
//

import UIKit

class StarAnimationView: UIView {
    
    // 每一段的宽度比例
    static let firstStep: CGFloat = 0.4
    static let secStep: CGFloat = 0.2
    static let thirdStep: CGFloat = 0.1
    static let fourStep: CGFloat = 0.3
    
    fileprivate var animationPath: UIBezierPath?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        print("draw")
        
        // 画出动画的路径
        if let context = UIGraphicsGetCurrentContext() {
            UIGraphicsPushContext(context)
            let animationPath = getStarAnimationPath()
            UIColor.red.setStroke()
            animationPath.lineWidth = 2.0
            animationPath.stroke()
            UIGraphicsPopContext()
        }
    }
    
    // MARK: -
    
    /// 根据需求放到一个group中
    func biuStar() {
        let starLayer = getStarLayer()
        starLayer.frame = CGRect(x: -20, y: bounds.height*0.5-10, width: 20, height: 20)
        layer.addSublayer(starLayer)
        
        let starAnimation = getStarAnimation()
        starAnimation.delegate = self
        starLayer.add(starAnimation, forKey: "starAnimation")
    }

    
    // MARK: -
    
    /// 获取一个star layer
    fileprivate func getStarLayer() -> CALayer {
        let layer = CALayer()
//        layer.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        layer.contents = UIImage(named: "xingxing")?.cgImage
        layer.contentsGravity = CALayerContentsGravity.resizeAspect
        return layer
    }
    
    fileprivate func getStarAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation.init(keyPath: "position")
        animation.path = getStarAnimationPath().cgPath
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.fillMode = .forwards
        animation.duration = 3
        animation.isRemovedOnCompletion = true
        return animation
    }
    
    @discardableResult
    fileprivate func getStarAnimationPath() -> UIBezierPath {
        if let path = self.animationPath {
            return path
        }
        print("xxx")
        let rect = bounds
        
        let animationPath = UIBezierPath()
        
        // 抛物线动画路径
        let firstStep_Width = rect.width*StarAnimationView.firstStep
        let firstStep_StartPoint = CGPoint.init(x: 0, y: rect.height/2.0)
        let firstStep_EndPoint = CGPoint.init(x: firstStep_Width, y: rect.height)
        // 抛物线动画
        let firstStep_controlPointEY: CGFloat = 80.0
        let firstStep_controlPointEX: CGFloat = firstStep_Width*0.25
        let firstStep_controlPoint1 = CGPoint.init(x: 0+firstStep_Width*0.5-firstStep_controlPointEX, y: firstStep_StartPoint.y-firstStep_controlPointEY)
        let firstStep_controlPoint2 = CGPoint.init(x: 0+firstStep_Width*0.5+firstStep_controlPointEX, y: firstStep_StartPoint.y-firstStep_controlPointEY)
        
        // 添加第一段路径
        animationPath.move(to: firstStep_StartPoint)
        animationPath.addCurve(to: firstStep_EndPoint, controlPoint1: firstStep_controlPoint1, controlPoint2: firstStep_controlPoint2)
        
        let secStep_Width = rect.width*StarAnimationView.secStep
        let secStep_StartPoint = firstStep_EndPoint
        let secStep_EndPoint = CGPoint.init(x: secStep_StartPoint.x+secStep_Width, y: rect.height)
        let secStep_controlPoint = CGPoint.init(x: secStep_StartPoint.x+secStep_Width*0.5, y: rect.height-secStep_Width*0.8)
        
        // 添加第二个路径
        animationPath.addQuadCurve(to: secStep_EndPoint, controlPoint: secStep_controlPoint)
        
        let thirdStep_Width = rect.width*StarAnimationView.thirdStep
        let thirdStep_StartPoint = secStep_EndPoint
        let thirdStep_EndPoint = CGPoint.init(x: thirdStep_StartPoint.x+thirdStep_Width, y: rect.height)
        let thirdStep_controlPoint = CGPoint.init(x: thirdStep_StartPoint.x+thirdStep_Width*0.5, y: rect.height-thirdStep_Width*0.8)
        
        // 添加第三个路径
        animationPath.addQuadCurve(to: thirdStep_EndPoint, controlPoint: thirdStep_controlPoint)
        
        // 第四段分为两个部分
        let fourStep_EndY: CGFloat = firstStep_StartPoint.y+(rect.height-firstStep_StartPoint.y)*0.6
        let fourStep_StartPoint = thirdStep_EndPoint
        let fourStep_EndPoint = CGPoint.init(x: rect.width, y: fourStep_EndY)

        let cor_Height = (rect.height-fourStep_EndPoint.y)*1.0
//        animationPath.addLine(to: CGPoint(x: fourStep_StartPoint.x, y: fourStep_EndY+cor_Height)) //去掉避免卡一下
        animationPath.addQuadCurve(to: CGPoint(x: fourStep_StartPoint.x+cor_Height, y: fourStep_EndPoint.y),
                                   controlPoint: CGPoint(x: fourStep_StartPoint.x, y: fourStep_EndPoint.y))
        animationPath.addLine(to: fourStep_EndPoint)
        self.animationPath = animationPath
        return animationPath
    }
}

extension StarAnimationView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let layer = layer.sublayers?.first {
            layer.removeFromSuperlayer()
        }
    }
}

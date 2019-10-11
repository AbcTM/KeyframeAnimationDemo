//
//  ViewController.swift
//  AnimationDemo
//
//  Created by tm on 2019/10/10.
//  Copyright © 2019 tm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let timer = DispatchSource.makeTimerSource()
    let timer2 = DispatchSource.makeTimerSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let starAnimationView = StarAnimationView()
        starAnimationView.backgroundColor = UIColor.groupTableViewBackground
        starAnimationView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: 240)
        view.addSubview(starAnimationView)
        
        let circularAnimationView = CircularAnimationView()
        circularAnimationView.backgroundColor = UIColor.groupTableViewBackground
        circularAnimationView.frame = CGRect.init(x: 40.0, y: starAnimationView.frame.maxY+10, width: view.frame.width-40.0*2, height: 60)
        view.addSubview(circularAnimationView)
        
        timer.setEventHandler {
            DispatchQueue.main.async {
                starAnimationView.biuStar()
                circularAnimationView.biuCircular()
            }
        }
        timer.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.milliseconds(300))
        timer.resume()
        
    }


}


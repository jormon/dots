//
//  ViewController.swift
//  dots
//
//  Created by Jordan Moncharmont on 3/6/16.
//  Copyright © 2016 Falcosoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var dotView: DotView!

    var timer: NSTimer?
    var lastTouch: CGPoint?

    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    @IBAction func viewDoubleTapped(sender: UITapGestureRecognizer) {
        timer?.invalidate()
        dotView.reset()
    }

    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        lastTouch = sender.locationInView(dotView)

        // invalidate any old ones
        timer?.invalidate()

        // kick off a new timer if needed
        if dotView.dotCount > 0 {
            timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.02), target: self, selector: "timerTriggered", userInfo: nil, repeats: true)
        }
    }

    func timerTriggered() {
        if dotView.dotCount > 0 {
            if let touch = lastTouch {
                if let p = dotView.removeDotClosestTo(touch) {
                    lastTouch = p
                }
            }
        } else {
            timer?.invalidate()
        }
    }
}
//
//  DotView.swift
//  dots
//
//  Created by Jordan Moncharmont on 3/6/16.
//  Copyright © 2016 Falcosoft. All rights reserved.
//

import UIKit

@IBDesignable
class DotView : UIView {
    @IBInspectable var numberOfDots: Int = 30

    @IBInspectable var dotSize: CGFloat = 5.0

    var dotCount: Int {
        get {
            return dots.count
        }
    }

    private lazy var dots: [CGRect] = {
        return self.generateDots()
    }()

    // MARK: drawing code

    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()

        for dot in dots {
            CGContextFillEllipseInRect(ctx, dot)
        }
    }

    // MARK: public interface

    func reset() {
        dots = generateDots()
        setNeedsDisplay()
    }

    func removeDotClosestTo(point: CGPoint) -> CGPoint? {
        guard dots.count > 0 else { return nil }

        dots.sortInPlace { (a, b) -> Bool in
            let aCenter = CGPoint(x: a.midX, y: a.midY)
            let bCenter = CGPoint(x: b.midX, y: b.midY)

             return CGPoint.dist(aCenter, b: point) < CGPoint.dist(bCenter, b: point)
        }

        let p = dots.removeFirst().origin

        setNeedsDisplay()

        return p
    }

    // MARK: dot generation

    private func generateDots() -> [CGRect] {
        let maxX = bounds.width
        let maxY = bounds.height

        let constrainedMaxX = maxX - dotSize
        let constrainedMaxY = maxY - dotSize

        var _dots = [CGRect]()

        for _ in 0...numberOfDots {
            let randX = CGFloat.random(constrainedMaxX)
            let randY = CGFloat.random(constrainedMaxY)

            let origin = CGRect(x: randX, y: randY, width: dotSize, height: dotSize)
            _dots.append(origin)
        }

        return _dots
    }
}


private extension CGPoint {
    static func dist(a: CGPoint, b: CGPoint) -> CGFloat {
        let xDistance = abs(a.x - b.x)
        let yDistance = abs(a.y - b.y)

        // approximate distance for speed
//        return xDistance + yDistance
//        return pow(xDistance, 2) + pow(yDistance, 2)
        return sqrt(pow(xDistance, 2) + pow(yDistance, 2))
    }
}

private extension CGFloat {
    static func random(max: CGFloat) -> CGFloat {
        return  CGFloat(arc4random() % UInt32(max))
    }

    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

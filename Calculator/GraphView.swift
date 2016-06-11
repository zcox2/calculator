//
//  GraphView.swift
//  Calculator
//
//  Created by Zachary Cox on 6/11/16.
//  Copyright © 2016 Zachary Cox. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    var lineWidth: CGFloat = 5.0
    var lineColor = UIColor.blackColor()
    var origin: CGPoint {
        get {
            return CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }
    
    
    var newPoint = CGPoint(x: 2.6, y: 4.0)
    
    var pointsPerUnit: CGFloat = 50
    var translatedNewPoint = CGPoint()
    
    var maxRun: CGFloat = 3.5
    var maxRise: CGFloat = 5.3
    
    
    private func translatePoint(point: CGPoint) -> CGPoint {
        var returnedPoint = CGPoint()
        returnedPoint.x = point.x * pointsPerUnit
        returnedPoint.y = point.y * pointsPerUnit
        return returnedPoint
    }
    
    func graphWithSlope(slope: Double) {
        let m = CGFloat(slope)
        var x = CGFloat()
        var y = CGFloat()
        
        if m <= maxRise / maxRun {
            x = maxRun
            y = x * m
        } else {
            y = maxRise
            x = y / m
        }
        newPoint = CGPoint(x: x, y: y)
        setNeedsDisplay()
    }
    

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    let axisDrawer = AxesDrawer()
    
    override func drawRect(rect: CGRect) {
        
        axisDrawer.drawAxesInRect(bounds, origin: CGPoint(x: origin.x, y: origin.y), pointsPerUnit: pointsPerUnit)
        
        let newLine = UIBezierPath()
        newLine.lineWidth = lineWidth
        lineColor.setStroke()
        
        newLine.moveToPoint(CGPoint(
            x: bounds.midX,
            y: bounds.midY)
        )
        newLine.addLineToPoint(CGPoint(
            x: origin.x + newPoint.x * pointsPerUnit,
            y: origin.y - newPoint.y * pointsPerUnit)
        )
        //newLine.addLineToPoint(CGPoint(x: translatePoint(newPoint).x, y: translatePoint(newPoint).y))
        newLine.stroke()
    }


}

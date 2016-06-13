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
    
    
    var startPoint = CGPoint()
    var endPoint = CGPoint()
    
    var pointsPerUnit: CGFloat = 50
    var translatedNewPoint = CGPoint()
    
    
    private func pointInGraphView(point: CGPoint) -> CGPoint {
        return CGPoint(
            x: origin.x + point.x * pointsPerUnit,
            y: origin.y - point.y * pointsPerUnit
        )
    }
    
    func graphWithSlope(slope: Double) {
        let m = CGFloat(slope)
        var x = CGFloat()
        var y = CGFloat()
        
        let maxX = bounds.width / 2 / pointsPerUnit
        let maxY = bounds.height / 2 / pointsPerUnit
        
        if m <= maxY / maxX {
            x = maxX
            y = x * m
        } else {
            y = maxY
            x = y / m
        }
        startPoint = CGPoint(x: -x, y: -y)
        endPoint = CGPoint(x: x, y: y)
        setNeedsDisplay()
    }
    func graphWithOperation(operation: (CGFloat) -> CGFloat) {
        
        let x = CGFloat(3.14)
        let y = operation(x)
        print(y)
        print(String(operation))
        
//        let maxX = bounds.width / 2 / pointsPerUnit
//        let maxY = bounds.height / 2 / pointsPerUnit
        
        
        
    }
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
        case ClearDisplay
        case Undo
    }
    

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    let axisDrawer = AxesDrawer()
    
    override func drawRect(rect: CGRect) {
        axisDrawer.contentScaleFactor = self.contentScaleFactor
        axisDrawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: pointsPerUnit)
        
        let newLine = UIBezierPath()
        newLine.lineWidth = lineWidth
        lineColor.setStroke()
        
        newLine.moveToPoint(pointInGraphView(startPoint))
        newLine.addLineToPoint(pointInGraphView(endPoint))
        
        newLine.stroke()
    }


}

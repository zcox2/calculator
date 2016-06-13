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
    
    var operation: (Double) -> Double = {_ in return 0}
    
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
        var i = 0
        let x = CGFloat(3.14)
        let y = operation(x)
        
        print(y)
        print(String(operation))
        
        
    }
    
    func graphIt() -> UIBezierPath {

        
        let maxX = bounds.width / 2 / pointsPerUnit // maxX is in graph units
        // let maxY = bounds.height / 2 / pointsPerUnit // maxY is in graph units
        var x = -Double(maxX)
        var y = operation(x)
        
        
        let line = UIBezierPath()
        line.lineWidth = lineWidth
        lineColor.setStroke()
        line.moveToPoint(pointInGraphView(CGPoint(x: x, y: y)))
        print("width: \(bounds.width), height: \(bounds.height)")
        print("max x:\(x) , max y:\(y) at \(pointInGraphView(CGPoint(x: x, y: y)).x) , \(pointInGraphView(CGPoint(x: x, y: y)).y)")
        while(x < Double(maxX)) {
            x += 1 / Double(pointsPerUnit)
            y = operation(x)
            line.addLineToPoint(pointInGraphView(CGPoint(x: x, y: y)))
            print("\(pointInGraphView(CGPoint(x: x, y: y)).x), \(pointInGraphView(CGPoint(x: x, y: y)).y)")
        }
        print("min x:\(x) , min y:\(y)")
        return line
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
        
//        let newLine = UIBezierPath()
//        newLine.lineWidth = lineWidth
//        lineColor.setStroke()
//        
//        newLine.moveToPoint(pointInGraphView(startPoint))
//        newLine.addLineToPoint(pointInGraphView(endPoint))
//        
//        newLine.stroke()
        let line = graphIt()
        line.stroke()
       
    }


}

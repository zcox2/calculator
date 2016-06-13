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
    var graphProgram = [AnyObject]()
    let brain = CalculatorBrain()
    
    var origin = CGPointZero { didSet { setNeedsDisplay() } }
    var pointsPerUnit: CGFloat = 50 { didSet { setNeedsDisplay() } }
    
    var operation: (Double) -> Double = {_ in return 0}
    
    let axisDrawer = AxesDrawer()
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Changed, .Ended:
            pointsPerUnit *= recognizer.scale
            print(pointsPerUnit)
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    func panOrigin(recognizer: UIPanGestureRecognizer) {
        recognizer.minimumNumberOfTouches = 1
        switch recognizer.state {
        case .Changed, .Ended:
            origin = CGPoint(
                x: origin.x + recognizer.translationInView(self).x,
                y: origin.y + recognizer.translationInView(self).y)
            recognizer.setTranslation(CGPointZero, inView: self)
        default:
            break
        }
    }
    
    private func pointInGraphView(point: CGPoint) -> CGPoint {
        return CGPoint(
            x: origin.x + point.x * pointsPerUnit,
            y: origin.y - point.y * pointsPerUnit
        )
    }
    
    private func pointInGraphUnits(point: CGPoint) -> CGPoint {
        return CGPoint(
            x: origin.x + point.x * pointsPerUnit,
            y: origin.y - point.y * pointsPerUnit
        )
    }
    func runCalculatorProgram(program: [AnyObject]) -> UIBezierPath {
        graphProgram = program
        brain.program = program
        let minX: CGFloat = -origin.x / pointsPerUnit // maxX and minX is in graph units
        let maxX: CGFloat = (bounds.width - origin.x) / pointsPerUnit
        var x = Double(minX)
        var y = Double(0)
        brain.variableValues["x"] = x
        
        if brain.result.isNaN {
            y = 0
        } else {
            y = brain.result
        }
        
        let line = UIBezierPath()
        line.moveToPoint(pointInGraphView(CGPoint(x: x, y: y)))
        
        while(x < Double(maxX)) {
            x += 5 / Double(pointsPerUnit)
            print("evaluating \(x)")
            brain.variableValues["x"] = Double(x)
            if brain.result.isNaN {
                y = 0
            } else {
                y = brain.result
            }
            line.addLineToPoint(pointInGraphView(CGPoint(x: x, y: y)))
        }
        return line
    }
    
    func generateLineFromStoredOperation() -> UIBezierPath {
        let minX = -origin.x / pointsPerUnit // maxX and minX is in graph units
        let maxX = (bounds.width - origin.x) / pointsPerUnit
        var x = Double(minX)
        var y = operation(x)
        let line = UIBezierPath()
        line.moveToPoint(pointInGraphView(CGPoint(x: x, y: y)))
        
        while(x < Double(maxX)) {
            x += 1 / Double(pointsPerUnit)
            y = operation(x)
            line.addLineToPoint(pointInGraphView(CGPoint(x: x, y: y)))
        }
        return line
    }
    
    override func drawRect(rect: CGRect) {
        
        axisDrawer.contentScaleFactor = self.contentScaleFactor
        axisDrawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: pointsPerUnit)
        
        var line = UIBezierPath()
        
        if graphProgram.count > 0 {
            line = runCalculatorProgram(graphProgram)
        } else {
            line = generateLineFromStoredOperation()
        }
        
        line.lineWidth = lineWidth
        lineColor.setStroke()
        line.stroke()
        
        
    }
    
    
}

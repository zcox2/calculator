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
        } set {
            newOrigin = newValue
            originHasChanged = true
        }
    }
    var newOrigin = CGPoint()
    var originHasChanged = false
    
    var operation: (Double) -> Double = {_ in return 0}
    
    var startPoint = CGPoint()
    var endPoint = CGPoint()
    
    var pointsPerUnit: CGFloat = 50 { didSet { setNeedsDisplay() } }
    var translatedNewPoint = CGPoint()
    
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
    
    private func pointInGraphView(point: CGPoint) -> CGPoint {
        if originHasChanged {
            return CGPoint(
                x: newOrigin.x + point.x * pointsPerUnit,
                y: newOrigin.y - point.y * pointsPerUnit
            )
        } else {
            return CGPoint(
                x: origin.x + point.x * pointsPerUnit,
                y: origin.y - point.y * pointsPerUnit
            )
        }
        
    }
    
    private func pointInGraphUnits(point: CGPoint) -> CGPoint {
        if originHasChanged {
            return CGPoint(
                x: (point.x - newOrigin.x) / pointsPerUnit,
                y: (point.y - newOrigin.y) / pointsPerUnit
            )
        } else {
            return CGPoint(
                x: origin.x + point.x * pointsPerUnit,
                y: origin.y - point.y * pointsPerUnit
            )
        }
    }
    
    func generateLineFromStoredOperation() -> UIBezierPath {
        if originHasChanged {
            let minX = -newOrigin.x / pointsPerUnit // maxX is in graph units
            let maxX = (bounds.width - newOrigin.x) / pointsPerUnit
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
        } else {
            let minX = -origin.x / pointsPerUnit // maxX is in graph units
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
        
    }
    
    let axisDrawer = AxesDrawer()
    
    override func drawRect(rect: CGRect) {
        if originHasChanged {
            axisDrawer.contentScaleFactor = self.contentScaleFactor
            axisDrawer.drawAxesInRect(bounds, origin: newOrigin, pointsPerUnit: pointsPerUnit)
        } else {
            axisDrawer.contentScaleFactor = self.contentScaleFactor
            axisDrawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: pointsPerUnit)
        }
        
        let line = generateLineFromStoredOperation()
        
        line.lineWidth = lineWidth
        lineColor.setStroke()
        line.stroke()
    }
    
    
}

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
    
    var pointsPerUnit: CGFloat = 50
    var translatedNewPoint = CGPoint()
    
    
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
    
    func generateLineFromStoredOperation() -> UIBezierPath {
        let maxX = bounds.width / 2 / pointsPerUnit // maxX is in graph units
        var x = -Double(maxX)
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
    
    let axisDrawer = AxesDrawer()
    
    override func drawRect(rect: CGRect) {
        axisDrawer.contentScaleFactor = self.contentScaleFactor
        axisDrawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: pointsPerUnit)
        
        let line = generateLineFromStoredOperation()
        
        line.lineWidth = lineWidth
        lineColor.setStroke()
        line.stroke()
    }
    
    
}

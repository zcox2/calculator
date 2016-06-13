//
//  GraphViewController.swift
//  Calculator
//
//  Created by Zachary Cox on 6/11/16.
//  Copyright © 2016 Zachary Cox. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    var slope: Double = 0.0
    var operation: (Double) -> Double = (sin)
    var program = [AnyObject]()


    @IBAction func setNewOrigin(tapRecognizer: UITapGestureRecognizer) {
        tapRecognizer.numberOfTapsRequired = 2
        print(tapRecognizer.locationInView(graphView))
        graphView.origin = tapRecognizer.locationInView(graphView)
        updateUI()
    }

    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: graphView, action: #selector(GraphView.changeScale(_:))
                ))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(
                target: graphView, action: #selector(GraphView.panOrigin(_:) )
                ))
        }
    }
    
    func updateUI() {
        graphView.operation = operation
        if program.count > 0 {
            graphView.graphProgram = program
        }
        graphView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        graphView.origin = CGPoint(x: graphView.bounds.midX, y: graphView.bounds.midY)
        updateUI()
    }


}

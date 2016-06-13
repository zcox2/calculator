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


    @IBAction func setNewOrigin(tapRecognizer: UITapGestureRecognizer) {
        tapRecognizer.numberOfTapsRequired = 2
        print(tapRecognizer.locationInView(graphView))
        graphView.origin = tapRecognizer.locationInView(graphView)
        updateUI()
    }

    @IBAction func zoom(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Changed, .Ended:
            graphView.pointsPerUnit *= recognizer.scale
            print(graphView.pointsPerUnit)
            recognizer.scale = 1.0
            updateUI()
        default: break
        }
        
    }
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            updateUI()
            
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
        graphView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.origin = CGPoint(x: graphView.bounds.midX, y: graphView.bounds.midY)
        // Do any additional setup after loading the view.
        
    }
    deinit {
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

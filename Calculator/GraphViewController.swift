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
    var numGraphView: Int = 0


    @IBOutlet weak var graphView: GraphView! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        graphView.operation = operation
        graphView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        numGraphView += 1
        print(numGraphView)
        
    }
    deinit {
        numGraphView -= 1
        print(numGraphView)
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

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


    @IBOutlet weak var graphView: GraphView! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        graphView.setNeedsDisplay()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        graphView.graphWithSlope(slope)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    
//    var destinationvc = segue.destinationViewController
//    if let navcon = destinationvc as? UINavigationController {
//        destinationvc = navcon.visibleViewController ?? destinationvc
//    }
//    if let facevc = destinationvc as? FaceViewController {
//        if let identifier = segue.identifier {
//            if let expression = emotionalFaces[identifier] {
//                facevc.expression = expression
//                if let sendingButton = sender as? UIButton {
//                    facevc.navigationItem.title = sendingButton.currentTitle
//                }
//            }
//        }
//    }



}

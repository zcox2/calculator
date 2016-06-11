//
//  GraphViewController.swift
//  Calculator
//
//  Created by Zachary Cox on 6/11/16.
//  Copyright © 2016 Zachary Cox. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    @IBOutlet weak var graphView: GraphView! {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        graphView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destinationVC = segue.destinationViewController
        
        if let navcon = destinationVC as? UINavigationController {
            destinationVC = navcon.visibleViewController ?? destinationVC
        }
        if let calculatorVC = destinationVC as? CalculatorViewController {
            if segue.identifier == "graph" {
                
                print(calculatorVC.descrip?.text ?? "No program")
                
                if calculatorVC.descrip.text != nil {
                    calculatorVC.navigationItem.title = calculatorVC.descrip.text
                }
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
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

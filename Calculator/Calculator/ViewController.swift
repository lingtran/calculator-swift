//
//  ViewController.swift
//  Calculator
//
//  Created by Ling Tran on 30/03/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel?
    
    @IBAction func touchDigit(_ sender: UIButton ) {
        let digit = sender.currentTitle!
        let textCurrentlyInDisplay = display!.text!
        display!.text = textCurrentlyInDisplay + digit
     
        
    }


}


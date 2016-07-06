//
//  SettingsViewController.swift
//  Reaction Time2
//
//  Created by Kent Drescher on 7/5/16.
//  Copyright © 2016 Kent_Drescher. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var durationLbl: UILabel!
    
    @IBOutlet weak var lowIntervalLbl: UILabel!
    
    @IBOutlet weak var highIntervalLbl: UILabel!
    
    @IBOutlet weak var durStepper: UIStepper!
    
    @IBOutlet weak var lowStepper: UIStepper!
    
    @IBOutlet weak var highStepper: UIStepper!
    
    @IBAction func backPress(sender: AnyObject) {
    
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changePress(sender: AnyObject) {
        
        DURATION = Int(durationLbl.text!)!
        LOW_INTERVAL = Int(lowIntervalLbl.text!)!
        HIGH_INTERVAL = Int(highIntervalLbl.text!)!
        print("Dur = \(durationLbl.text) lo=\(lowIntervalLbl.text) hi=\(highIntervalLbl.text)")
    
    }
    
    @IBAction func durationChg(sender: UIStepper) {
    
        durationLbl.text = Int(sender.value).description

    }
    
    @IBAction func lowIntChg(sender: UIStepper) {
       
        lowIntervalLbl.text = Int(sender.value).description
    
    }
    
    @IBAction func highIntChg(sender: UIStepper) {
    
        highIntervalLbl.text = Int(sender.value).description
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        durStepper.value = Double(DURATION)
        durationLbl.text = String(DURATION)
        lowStepper.value = Double(LOW_INTERVAL)
        lowIntervalLbl.text = String(LOW_INTERVAL)
        highStepper.value = Double(HIGH_INTERVAL)
        highIntervalLbl.text = String(HIGH_INTERVAL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

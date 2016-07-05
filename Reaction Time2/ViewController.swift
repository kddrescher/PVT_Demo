//
//  ViewController.swift
//  Reaction Time Task
//
//  Created by Kent Drescher on 7/1/16.
//  Copyright © 2016 Kent_Drescher. All rights reserved.
//

import UIKit

var lblStr = String()

class ViewController: UIViewController, UITextFieldDelegate {
    
    var id = String()
    
    var trialsArray = [NSTimeInterval]()
    var waitArray = [Double]()
    
    var countDown = 0
    
    var timer = NSTimer()
    let timeInterval:NSTimeInterval = 0.005
    var timerEnd:NSTimeInterval = 10.0
    var timeCount:NSTimeInterval = 0.0
    var waitEnd:NSTimeInterval = 0.0
    var waitCount:NSTimeInterval = 0.0
    var respEnd:NSTimeInterval = 0.0
    var respCount:NSTimeInterval = 0.0
    var isTiming = false
    var isWaiting = false
    var isResponding = false
    var isTestComplete = false
    var lblStr = String()
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var trialsTextField: UITextField!
    
    @IBOutlet weak var instructLabel: UILabel!
    
    @IBOutlet weak var stepLbl: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var responseButton: UIButton!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBAction func infoPress(sender: AnyObject) {
        
        
        let msgString = "INSTRUCTIONS: After entering ID# and test duration, Press Red Start button to begin.  Each time you see red numbers in this white box, press the PRESS to RESPOND button as quickly as possible”"
        
        let alert = UIAlertController(title: "Psychomotor Vigilence Task", message: msgString, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func startTimer(sender:AnyObject) {
        
        id = idTextField.text!
        timerEnd = Double(stepLbl.text!)! * 60
        
        if (!timer.valid) {
            isTiming = true
            
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self,selector: #selector(ViewController.timerDidEnd(_:)), userInfo: "Test Complete!!", repeats: true)
            print("timing start")
        }
        //start wait for first trial
        instructLabel.text = ""
        
        waitEnd = Double(randInRange(200...400))/100
        waitArray.append(waitEnd)
        isWaiting = true
        
    }
    
    func timeString(time:NSTimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        return String(format:"%01i.%03i",Int(seconds),Int(secondsFraction * 1000.0))
    }
    
    func waitString(time:NSTimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        return String(format:"%01i.%01i",Int(seconds),Int(secondsFraction * 10.0))
    }
    
    
    func randInRange(range: Range<Int>) -> Int {
        
        return Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex))) + range.startIndex
        
    }
    
    func startResponse() {
        waitCount = 0.0
        responseButton.enabled = true
        isResponding = true
        
    }
    
    func reportData() {
        
        var outputStr = id + ", " + String(trialsArray.count)
        lblStr = "id, num"
        
        for i in 0...trialsArray.count-1 {
            outputStr = outputStr + ", " +  waitString(waitArray[i]) + ", " + timeString(trialsArray[i])
            lblStr = lblStr + ", w\(i+1), rt\(i+1)"
            
        }
        lblStr = lblStr + "\n" + outputStr
        //print(lblStr)
        //instructLabel.textAlignment = NSTextAlignment.Left
        //instructLabel.font = UIFont.systemFontOfSize(11)
        //instructLabel.text = lblStr
        shareButton.enabled = true
        
    }
    
    func timerDidEnd(timer:NSTimer){
        
        timeCount = timeCount + timeInterval
        //print("TC = \(timeCount)")
        if timeCount >= timerEnd{  //test time completed
            
            timer.invalidate()
            isTestComplete = true
            instructLabel.text = "Test Complete - " + timeString(timeCount)
            reportData()
            
        } else { //update the time on the clock if not reached
            
            if isWaiting {
                
                waitCount = waitCount + timeInterval
                if waitCount >= waitEnd {
                    isWaiting = false
                    startResponse()
                    //print("Waiting Done")
                }
            }
            if isResponding {
                
                respCount = respCount + timeInterval
                instructLabel.text = "\(Int(respCount*1000))"
            }
            
        }
        
    }
    
    @IBAction func stepperChange(sender: UIStepper) {
        stepLbl.text = Int(sender.value).description
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        //instructLabel.text = "Waiting..."
        instructLabel.textColor = UIColor.redColor()
        instructLabel.backgroundColor = UIColor.whiteColor()
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    @IBAction func respondPress(sender: AnyObject) {
        isResponding = false
        trialsArray.append(respCount)
        print("Resp Time: \(Int(respCount*1000))")
        respCount = 0.0
        
        //start waiting again
        instructLabel.text = ""
        waitEnd = Double(randInRange(200...400))/100
        waitArray.append(waitEnd)
        isWaiting = true
        responseButton.enabled = false
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "outputSegue" {
            let vc = segue.destinationViewController as! OutputViewController
            
            vc.incomingText = lblStr
            
        }
    }
    
}


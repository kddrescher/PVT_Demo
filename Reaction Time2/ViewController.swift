//
//  ViewController.swift
//  Reaction Time Task
//
//  Created by Kent Drescher on 7/1/16.
//  Copyright © 2016 Kent_Drescher. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

var DURATION = 3
var LOW_INTERVAL = 2
var HIGH_INTERVAL = 10
var TIMEOUT = 30.0



class ViewController: UIViewController, UITextFieldDelegate {
    
    var allTestResults  = [NSManagedObject]()

    var id = String()
    var lblStr = String()
    var hdrStr = String()
    
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
    var falseStart = 0
    var lapse = 0
    
    var isTiming = false
    var isWaiting = false
    var isShowingTime = false
    var isResponding = false
    var isTestComplete = false
    
    @IBOutlet weak var exportButton: UIBarButtonItem!
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var trialsTextField: UITextField!
    
    @IBOutlet weak var instructLabel: UILabel!
    
    @IBOutlet weak var stepLbl: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var responseButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBAction func startTimer(sender:AnyObject) {
        
        //id = idTextField.text!
        timerEnd = Double(DURATION) * 60
        
        if (!timer.valid) {
            isTiming = true
            
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self,selector: #selector(ViewController.timerDidEnd(_:)), userInfo: "Test Complete!!", repeats: true)
            //print("timing start")
        }
        //setup for first trial
        instructLabel.font = UIFont.systemFontOfSize(22)
        instructLabel.textAlignment = NSTextAlignment.Center
        instructLabel.text = ""
        
        //set and record next inter-trial interval
        waitEnd = Double(randInRange((LOW_INTERVAL * 100)...(HIGH_INTERVAL * 100)))/100
        waitArray.append(waitEnd)
        
        //start wait for first trial
        isWaiting = true
        startButton.enabled = false
        responseButton.enabled = true
        
    }
    
    
    func timerDidEnd(timer:NSTimer){
        
        timeCount = timeCount + timeInterval
        //print("TC = \(timeCount)")
        if timeCount >= timerEnd{  //test time completed
            
            timer.invalidate()
            isTestComplete = true
            instructLabel.textColor = UIColor.redColor()
            instructLabel.text = "Test Complete"
            reportData()
            
        } else { //update the time on the clock if not reached
            
            if isWaiting {
                
                waitCount = waitCount + timeInterval
                
                if (waitCount >= 1.0) && isShowingTime {
                    isShowingTime = false
                    instructLabel.textColor = UIColor.redColor()
                    instructLabel.text = ""
                    responseButton.enabled = true
                }
                
                if waitCount >= waitEnd {
                    isWaiting = false
                    waitCount = 0.0
                    isResponding = true

                }
            }
            
            if isResponding {
                
                respCount = respCount + timeInterval
                instructLabel.text = "\(Int(respCount*1000))"
                
                if respCount >= TIMEOUT {
                    lblStr = "Timed Out"
                    isResponding = false
                    lapse+=1
                    recordTrial()
                }
            }
            
        }
        
    }
    
    
    @IBAction func respondPress(sender: AnyObject) {
        
        //Check for False Start
        if (isWaiting) {
            falseStart+=1
            waitCount = 0.0
            lblStr = "FALSE START"
            //print("\(falseStart) False Start(s)")
        }
        //Check for < 100ms
        if respCount > 0.0 && respCount <= 0.1 {
            falseStart+=1
            lblStr = "FALSE START"
            //print("\(falseStart) False Start(s)")
            
        }
        
        //Check for Lapse <30sec
        if respCount > 0.500 {
            lapse+=1
            //print("\(lapse) Lapse(s) Recorded \(respCount)")
        }
        recordTrial()
        
    }
    
    func recordTrial() {
        
        if lblStr == "Timed Out" {
            playSound()
        }

        //Record Trial time
        trialsArray.append(respCount)
        print("Resp Time: \(Int(respCount*1000))")
        isResponding = false

        //setup for next trial
        instructLabel.font = UIFont.systemFontOfSize(22)
        instructLabel.textAlignment = NSTextAlignment.Center
        
        //set and record next inter-trial interval
        waitEnd = Double(randInRange((LOW_INTERVAL * 100)...(HIGH_INTERVAL * 100)))/100
        waitArray.append(waitEnd)
        
        //start wait for next trial
        isWaiting = true
        isShowingTime = true
        instructLabel.textColor = UIColor.greenColor()
        if lblStr == "" {
            lblStr = "\(Int(respCount*1000))"
        }
        instructLabel.text = lblStr
        respCount = 0.0
        lblStr = ""
        
    }
    
    func reportData() {
        
        var median: Double
        var lapse: Int
        var falseSt: Int
        var lapsePR: Double
        var sumLFSt: Int
        var perfScr: Double
        var meanRT: Double
        var meanTrRT: Double
        var fastRT: Double
        var slowRT: Double
        
        var filteredArray = [Double]()
        var lapseArray = [Double]()
        
        filteredArray = trialsArray.filter({$0 > 0.100})
        filteredArray.sortInPlace {
            return $0 < $1 }
        
        //Median RT (does this include False Starts?  Assuming No)
        let med = Int(filteredArray.count / 2)
        median = filteredArray[med-1]
        print("Median = \(median)")
        
        //Mean RT (does this include False Starts?  Assuming No)
        var sum = 0.0
        for tr in filteredArray {
            sum = sum+tr
            print("tr \(tr)")
        }
        meanRT = sum / Double(filteredArray.count)
        print("meanRT = \(meanRT)")
        
        //Fastest 10% RT (is this Sum or Mean? Assuming mean)
        var tenth = Int(filteredArray.count / 10)
        if tenth == 0 {tenth = 1}
        
        print("tenth = \(tenth)")
        sum = 0.0
        for i in 0...tenth {
            sum = sum + filteredArray[i]
        }
        fastRT = sum / Double(tenth)
        print("fastRT = \(fastRT)")
        
        
        //Mean 1/RT
        sum = 0.0
        for tr in filteredArray {
            sum = sum + (1.0 - (tr))
            //print("1/RT \(1-(tr))")
        }
        meanTrRT = sum / Double(filteredArray.count)
        print("meanTrRT = \(meanTrRT)")
        
        // 10% 1/RT (is this Sum or Mean? Assuming mean)
        sum = 0.0
        
        for i in (filteredArray.count-1)-tenth...filteredArray.count-1 {
            sum = sum + (1.0 - filteredArray[i])
        }
        slowRT = sum / Double(tenth)
        print("slowRT = \(slowRT)")
        
        //Number of Lapses
        lapseArray = trialsArray.filter({$0 > 0.500})
        lapse = lapseArray.count
        print("lapse = \(lapse)")
        
        //Lapse Probability (i.e., number of lapses divided by the number of valid stimuli, excluding false starts)
        lapsePR = Double(lapse) / Double(filteredArray.count)
        print("lapsePR = \(lapsePR)")
        
        //Number of false starts
        falseSt = trialsArray.count - filteredArray.count
        print("falseSt = \(falseSt)")
        
        //Sum of Lapses and False Starts
        sumLFSt = lapse + falseSt
        print("sumLFSt = \(sumLFSt)")
        
        //Performance Score (i.e. defined as 1 minus the number of lapses and false starts divided by the number of valid stimuli (including false starts)
        perfScr = 1.0 - (Double(sumLFSt) / Double(trialsArray.count))
        print("perfScr = \(perfScr)")

        
        
        hdrStr = "trials, median, meanRT, fastRT, meanTrRT, slowRT, lapse, lapsePR, falseSt, sumLFSt, perfScr, "
        
        var outputStr = String(trialsArray.count) + ", \(median), \(meanRT), \(fastRT), \(meanTrRT), \(slowRT), \(lapse), \(lapsePR), \(falseSt), \(sumLFSt), \(perfScr), "
        
        for i in 0...trialsArray.count-1 {
            outputStr = outputStr + ", " +  waitString(waitArray[i]) + ", " + timeString(trialsArray[i])
            hdrStr = hdrStr + ", w\(i+1), rt\(i+1)"
            
        }

        hdrStr = hdrStr + "\n" + outputStr
        
        exportButton.enabled = true
        
        //Prepare to save test in Core Data
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        let today = formatter.stringFromDate(date)
        
        //Present Score and Save data to Core data the dismiss controller
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("PVTScores",
                                                        inManagedObjectContext:managedContext)
        
        let score = NSManagedObject(entity: entity!,
                                    insertIntoManagedObjectContext: managedContext)
        
        //3
        score.setValue(today, forKey: "testDate")
        score.setValue(median, forKey: "median")
        score.setValue(lapse, forKey: "lapse")
        score.setValue(falseSt, forKey: "falseSt")
        score.setValue(lapsePR, forKey: "lapsePR")
        score.setValue(sumLFSt, forKey: "sumLFSt")
        score.setValue(perfScr, forKey: "perfScr")
        score.setValue(meanRT, forKey: "meanRT")
        score.setValue(meanTrRT, forKey: "meanTrRT")
        score.setValue(fastRT, forKey: "fastRT")
        score.setValue(slowRT, forKey: "slowRT")
        score.setValue(hdrStr, forKey: "pvtCSV")
        
        //4
        do {
            try managedContext.save()
            //5
            allTestResults.append(score)
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
        //Reset variables for next test
        responseButton.enabled = false
        timerEnd = 10.0
        timeCount = 0.0
        waitEnd = 0.0
        waitCount = 0.0
        respEnd = 0.0
        respCount = 0.0
        falseStart = 0
        lapse = 0
        isTiming = false
        isWaiting = false
        isShowingTime = false
        isResponding = false
        isTestComplete = false
        
        startButton.enabled = true
        
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
    
    func playSound() {
        
        let systemSoundID: SystemSoundID = 1053
        AudioServicesPlaySystemSound (systemSoundID)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "PVTScores")
        
        request.returnsObjectsAsFaults = false
        
        
        do {
            let results =
                try context.executeFetchRequest(request)
            allTestResults = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        print("Core Data has \(allTestResults.count) test records")
        //print(allTestResultsS)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        instructLabel.font = UIFont.systemFontOfSize(13)
        instructLabel.textAlignment = NSTextAlignment.Left
        instructLabel.text = "INSTRUCTIONS: Press Red Start button to begin.  Each time you see red numbers in this white box, press the PRESS to RESPOND button as quickly as possible.  Make sure not to press before you see the red numbers."
        instructLabel.textColor = UIColor.redColor()
        instructLabel.backgroundColor = UIColor.whiteColor()

        responseButton.layer.cornerRadius = CGRectGetHeight(responseButton.bounds)/20
        responseButton.layer.shadowRadius = 4
        responseButton.layer.shadowOpacity = 0.5
        responseButton.layer.shadowOffset = CGSize.zero

        startButton.layer.cornerRadius = CGRectGetHeight(startButton.bounds)/4
        startButton.layer.shadowRadius = 4
        startButton.layer.shadowOpacity = 0.5
        startButton.layer.shadowOffset = CGSize.zero
        responseButton.enabled = false

    }
    
    override func viewDidDisappear(animated: Bool) {
        

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "settingstSegue" {
            let vc = segue.destinationViewController as! SettingsViewController
            
            
        }

        if segue.identifier == "outputSegue" {
            let vc = segue.destinationViewController as! UINavigationController
            
            
        }
        
        if segue.identifier == "exportSegue" {
            let vc = segue.destinationViewController as! OutputViewController
            
            vc.incomingText = hdrStr
            
        }

    }
    
}


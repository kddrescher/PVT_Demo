//
//  ScoresTableViewController.swift
//  Reaction Time2
//
//  Created by Kent Drescher on 7/9/16.
//  Copyright © 2016 Kent_Drescher. All rights reserved.
//

import UIKit
import CoreData



class ScoresTableViewController: UITableViewController {

    @IBAction func backPress(sender: AnyObject) {
    
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    var testScores = ["median", "meanRT", "fastRT", "meanTrRT", "slowRT", "lapse", "lapsePR", "falseSt", "sumLFSt", "perfScr"]
    
    var scoreDesc = ["Median of completed trials", "Average of valid reaction times", "Average of the fastest 10% of reaction times", "Average of reciprocal reaction times (1/RT)", "Average of the slowest 10% of reciprocal 1/RT", "Number of Lapses", "Lapse Probability", "Number of false starts", "Sum of Lapses and False Starts", "Performance Score" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return testScores.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        cell.textLabel?.text = testScores[indexPath.row]
        cell.detailTextLabel?.text = scoreDesc[indexPath.row]
        
        return cell
    }
   
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Row \(indexPath.row) \(testScores[indexPath.row])")
        
        // Load Test Scores from Core Data
        var myDates = [String]()
        var myScores = [Double]()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let request = NSFetchRequest(entityName: "PVTScores")
        //request.predicate = NSPredicate(format: "testName = %@", testScores[indexPath.row])
        request.returnsObjectsAsFaults = false
        
        do {
            let results =
                try context.executeFetchRequest(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let date = result.valueForKey("testDate") as? String {
                        myDates.append(date)
                    }

                    if testScores[indexPath.row] == "lapse" || testScores[indexPath.row] == "falseSt" || testScores[indexPath.row] == "sumLFSt" {
                        //Int Values
                        if let score = result.valueForKey(testScores[indexPath.row]) as? Int {
                            myScores.append(Double(score))
                        }
                        
                    } else {
                        //Double Values
                        if let score = result.valueForKey(testScores[indexPath.row]) as? Double {
                        myScores.append(score)
                        }
                        
                    }
                    
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("chartView") as! ChartViewController
        
        viewController.incomingDates = myDates
        viewController.incomingScores = myScores
        viewController.incomingName = testScores[indexPath.row]
        
        self.presentViewController(viewController, animated: false, completion: nil)
    
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

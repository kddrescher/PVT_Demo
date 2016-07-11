//
//  ChartViewController.swift
//  Reaction Time2
//
//  Created by Kent Drescher on 7/9/16.
//  Copyright © 2016 Kent_Drescher. All rights reserved.
//

import UIKit
import Charts


class ChartViewController: UIViewController {
    
    var incomingDates: [String]!
    var incomingScores: [Double]!
    var incomingName: String!
    
    @IBOutlet weak var NavigationItem: UINavigationItem!
    
    @IBOutlet weak var lineChartView: LineChartView!



    
    @IBAction func backPress(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print(incomingScores)
        
        setChart(incomingDates, values: incomingScores)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        NavigationItem.title = incomingName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        lineChartView.noDataText = "You need to provide data for the chart."
        lineChartView.descriptionText = ""
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData    }
    


    
    
}
//
//  OutputViewController.swift
//  Reaction Time Task
//
//  Created by Kent Drescher on 7/2/16.
//  Copyright © 2016 Kent_Drescher. All rights reserved.
//

import UIKit

class OutputViewController: UIViewController {
    
    var incomingText: String?
    
    @IBAction func backPress(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBOutlet weak var myTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        self.myTextView.text = self.incomingText
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

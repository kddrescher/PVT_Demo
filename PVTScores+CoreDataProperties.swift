//
//  PVTScores+CoreDataProperties.swift
//  Reaction Time2
//
//  Created by Kent Drescher on 7/9/16.
//  Copyright © 2016 Kent_Drescher. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PVTScores {

    @NSManaged var testDate: NSDate?
    @NSManaged var durMins: NSNumber?
    @NSManaged var lowInterval: NSNumber?
    @NSManaged var highInterval: NSNumber?
    @NSManaged var numTrials: NSNumber?
    @NSManaged var median: NSNumber?
    @NSManaged var lapse: NSNumber?
    @NSManaged var falseSt: NSNumber?
    @NSManaged var lapsePR: NSNumber?
    @NSManaged var sumLFSt: NSNumber?
    @NSManaged var perfScr: NSNumber?
    @NSManaged var meanRT: NSNumber?
    @NSManaged var meanTrRT: NSNumber?
    @NSManaged var fastRT: NSNumber?
    @NSManaged var slowRT: NSNumber?
    @NSManaged var pvtCSV: String?

}

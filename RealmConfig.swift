//
//  RealmConfig.swift
//  testRealm
//
//  Created by Olivier Corradi on 29/10/15.
//  Copyright © 2015 Snips. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig {
    
    static var dbPath: String {
        let url = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.net.snips.testRealm")
        
        return url!.URLByAppendingPathComponent("db.realm").path!
    }
    
}
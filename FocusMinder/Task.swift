//
//  Task.swift
//  FocusMinder
//
//  Created by Drew Westcott on 05/07/2016.
//  Copyright © 2016 Drew Westcott. All rights reserved.
//

import Foundation

class Task : NSObject {
    
    private var _title : String!
    private var _priority : Int!
    
    var title : String {
        return _title
    }
    
    var priority : Int {
        return _priority
    }
    
    init(title: String, priority: Int) {
        self._title = title
        self._priority = priority
    }
}
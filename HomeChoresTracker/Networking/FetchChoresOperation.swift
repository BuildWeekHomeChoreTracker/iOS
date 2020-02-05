//
//  FetchChoresOperation.swift
//  HomeChoresTracker
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class FetchChoresOperation: ConcurrentOperation {
    
    var childController: ChildController
    
    init(childController: ChildController) {
        self.childController = childController
    }
    override func start() {
        self.state = .isExecuting
        childController.getChores { error in
            defer { self.state = .isFinished }
            
            if let _ = error {
                return
            }
        }
    }
}

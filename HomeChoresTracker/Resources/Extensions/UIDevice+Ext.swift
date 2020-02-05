//
//  UIDevice+Ext.swift
//  HomeChoresTracker
//
//  Created by Chad Rutherford on 2/5/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

extension UIDevice {
    static var isSimulator: Bool = {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }()
}

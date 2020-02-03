//
//  RoundedButton.swift
//  HomeChoresTracker
//
//  Created by Chad Rutherford on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    private func sharedInit() {
        layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
}

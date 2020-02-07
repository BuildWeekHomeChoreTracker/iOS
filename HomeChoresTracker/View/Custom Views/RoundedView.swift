//
//  RoundedView.swift
//  HomeChoresTracker
//
//  Created by Chad Rutherford on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
    }
    
    func sharedInit() {
        layer.cornerRadius = 15.0
        clipsToBounds = true
    }
}

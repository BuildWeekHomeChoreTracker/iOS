//
//  SegueHandler.swift
//  HomeChoresTracker
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

protocol SegueHandler { associatedtype SegueIdentifier: RawRepresentable }

extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String {
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else { fatalError("Unknown segue: \(segue)") }
        return segueIdentifier
    }
    
    func performSegue(withIdentifier segueIdentifier: SegueIdentifier) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: nil)
    }
}

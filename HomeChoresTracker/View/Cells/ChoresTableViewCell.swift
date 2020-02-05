//
//  ChoresTableViewCell.swift
//  HomeChoresTracker
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ChoresTableViewCell: UITableViewCell {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Outlets
    @IBOutlet weak var choreImageView: UIImageView!
    @IBOutlet weak var choreTitleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var choreScoreLabel: UILabel!
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    var chore: ChoreRepresentation? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let chore = chore else { return }
        if let imageData = chore.image {
            choreImageView.image = UIImage(data: imageData)
        } else {
            choreImageView.image = UIImage(named: "chore_bg")
        }
        choreTitleLabel.text = chore.title
        choreScoreLabel.text = "\(chore.score ?? 0)"
    }
}
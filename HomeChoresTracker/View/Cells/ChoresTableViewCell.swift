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
    @IBOutlet private weak var choreImageView: UIImageView!
    @IBOutlet private weak var choreTitleLabel: UILabel!
    @IBOutlet private weak var dueDateLabel: UILabel!
    @IBOutlet private weak var choreScoreLabel: UILabel!
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    var chore: ChoreRepresentation? {
        didSet {
            updateViews()
        }
    }
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    private func updateViews() {
        guard let chore = chore else { return }
        
        if let imageData = chore.image {
            let dataDecoded: NSData = NSData(base64Encoded: imageData, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let decodedimage: UIImage = UIImage(data: dataDecoded as Data)!
            choreImageView.image = decodedimage
        } else {
            choreImageView.image = UIImage(named: "chore_bg")
        }
        choreTitleLabel.text = chore.title
        choreScoreLabel.text = "\(chore.score ?? 0)"
        dueDateLabel.text = dateFormatter.string(from: chore.dateFromString)
    }
}

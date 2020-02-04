//
//  ChoresTableViewController.swift
//  HomeChoresTracker
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ChoresTableViewController: UITableViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    var childController: ChildController?
    let choreFetchQueue = OperationQueue()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let controller = childController {
            let fetchChoresOp = FetchChoresOperation(childController: controller)
            let updateOp = BlockOperation {
                self.tableView.reloadData()
            }
            choreFetchQueue.addOperation(fetchChoresOp)
            updateOp.addDependency(fetchChoresOp)
            OperationQueue.main.addOperation(updateOp)
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Private
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childController?.chores.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .choreCell, for: indexPath) as? ChoresTableViewCell else { return UITableViewCell() }
        let chore = childController?.chores[indexPath.row]
        cell.chore = chore
        return cell
    }
}

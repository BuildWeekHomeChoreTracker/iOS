//
//  ChoresTableViewController.swift
//  HomeChoresTracker
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ChoresTableViewController: UITableViewController, SegueHandler {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    var childController: ChildController?
    let choreFetchQueue = OperationQueue()
    
    enum SegueIdentifier: String {
        case showChoreDetail = "ShowChoreDetailSegue"
    }
    
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
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .showChoreDetail:
            guard let choreDetailVC = segue.destination as? ChoreDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let chore = childController?.chores[indexPath.row] else { return }
            choreDetailVC.chore = chore
            choreDetailVC.childController = childController
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        childController?.chores.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .choreCell, for: indexPath) as? ChoresTableViewCell else { return UITableViewCell() }
        let chore = childController?.chores[indexPath.row]
        cell.chore = chore
        cell.childController = childController
        return cell
    }
}

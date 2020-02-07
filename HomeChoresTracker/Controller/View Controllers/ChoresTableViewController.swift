//
//  ChoresTableViewController.swift
//  HomeChoresTracker
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class ChoresTableViewController: UITableViewController, SegueHandler {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    var childController: ChildController?
    let choreFetchQueue = OperationQueue()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Chore> = {
        let fetchRequest: NSFetchRequest<Chore> = Chore.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "completed", ascending: true),
            NSSortDescriptor(key: "dueDate", ascending: false)
        ]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "completed", cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            guard let childController = childController,
                let mockChore = Chore(id: 1,
                                      childId: 6,
                                      parentId: 1,
                                      title: "Chop some trees",
                                      bonusPoints: 5,
                                      cleanStreak: 7,
                                      dueDate: Date(timeIntervalSinceNow: 900),
                                      information: "Chop them well",
                                      score: 9000),
                let rep = mockChore.choreRepresentation
                else { return frc }
            childController.chores = [rep]
        }
        return frc
    }()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Segue Handler
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
                let indexPath = tableView.indexPathForSelectedRow
                else { return }
            choreDetailVC.chore = fetchedResultsController.object(at: indexPath).choreRepresentation
            choreDetailVC.childController = childController
        }
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let chores = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        return chores
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: .choreCell, for: indexPath) as? ChoresTableViewCell else { return UITableViewCell() }
        let chore = fetchedResultsController.object(at: indexPath).choreRepresentation
        cell.chore = chore
        cell.childController = childController
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionData = fetchedResultsController.sections?[section] else { return nil }
        //0 false, 1 true
        if sectionData.name == "0" {
            return "Chores I need to do"
        } else {
            return "Chores I've done"
        }
    }
}

// MARK: - NSFetchedResultsController Delegate Methods
extension ChoresTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

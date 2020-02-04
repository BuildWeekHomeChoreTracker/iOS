//
//  ViewController.swift
//  HomeChoresTracker
//
//  Created by Kenny on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let childController = ChildController()
    var child: Child?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        childController.login(with: "johnnya", and: "123456") { (error) in //NOTE: Child with these credentials doesn't exist, implementing mock data on error
            if let error = error {
                print(error)
                self.child = self.childController.mockChild
                guard let child = self.child else {return}
                let chore = self.childController.mockChore
                //save to CoreData
                DispatchQueue.main.async {
                    chore.name = child.name
                    chore.parentName = child.parentName
                    child.addToChores(chore)
                    do {
                        try CoreDataStack.shared.save()
                    } catch {
                        print(error)
                    }
                    
                    guard let chores = self.childController.getChoresFromChild(child: child) else {return}
                    print(chores)
                }
                
            }
        }
    }


}


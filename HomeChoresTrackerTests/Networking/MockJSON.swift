//
//  MockJSON.swift
//  HomeChoresTrackerTests
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

let goodChores = """
{
  "chore": [
    {
      "id": 1,
      "name": "wash dishes",
      "description": "clean all dishes in sink.",
      "comments": null,
      "completed": 0,
      "due_date": null,
      "chore_score": 5,
      "bonus_pts": null,
      "clean_strk": null,
      "photo_obj": null,
      "child_id": 1,
      "parent_id": 1
    },
    {
      "id": 5,
      "name": "Rake Yard",
      "description": "rake all the yard",
      "comments": "if your smart you would use the leaf blower",
      "completed": 0,
      "due_date": "2020-02-08",
      "chore_score": 10,
      "bonus_pts": 4,
      "clean_strk": null,
      "photo_obj": null,
      "child_id": 1,
      "parent_id": 2
    }
  ]
}
""".data(using: .utf8)!

let badChores = """
[
    {
        "id": 1,
        "name": "wash dishes",
        "description": "clean all dishes in sink.",
        "comments": null,
        "completed": false,
        "due_date": null,
        "chore_score": 5,
        "bonus_pts": null,
        "clean_strk": null,
        "photo_obj": null
    },
    {
        "id": 2,
        "name": "wash clothes",
        "description": "wash all clothes in laundry room.",
        "comments": null,
        "completed": false,
        "due_date": null,
        "chore_score": 5,
        "bonus_pts": null,
        "clean_strk": null,
        "photo_obj": null
    },
    {
        "id": 3,
        "name": "clean room",
        "description": "pick up you room",
        "comments": null,
        "completed": false,
        "due_date": null,
        "chore_score": 5,
        "bonus_pts": null,
        "clean_strk": null,
        "photo_obj": null
""".data(using: .utf8)!

let noChores = """
{
  "chore": [ ]
}
""".data(using: .utf8)!


let child = """
{
    id: 1,
    fstname: "Josh",
    lstname: "Dimmick",
    username: "joshd",
    password: bcrypt.hashSync("test1", 12)
}
""".data(using: .utf8)!

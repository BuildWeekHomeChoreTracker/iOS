//
//  MockJSON.swift
//  HomeChoresTrackerTests
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

let goodChores = """
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
    }
]
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
    []
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

//
//  databaseRef.swift
//  rate my course
//
//  Created by chris on 4/5/19.
//  Copyright © 2019 com. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct refs
{
    static let databaseRoot = Database.database().reference()
    static let databaseComments = databaseRoot.child("Comments")
    static let databaseStatistics = databaseComments.child("Statistics")
}

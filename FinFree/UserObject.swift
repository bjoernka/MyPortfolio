//
//  UserObject.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 29/2/20.
//  Copyright © 2020 Björn Kaczmarek. All rights reserved.
//

import Foundation

struct UserObject {
    
    var uid: String = ""
    var username: String = ""
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
    }
}

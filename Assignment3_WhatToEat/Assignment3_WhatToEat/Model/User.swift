//
//  User.swift
//  Assignment3_WhatToEat
//
//  Created by Junhui Ye on 3/5/2025.
//

import FirebaseFirestore

struct User: Codable {
    let email: String
    var password: String
    let name: String
    var favourites: [String]?
}

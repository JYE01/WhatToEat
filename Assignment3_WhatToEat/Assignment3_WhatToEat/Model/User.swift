//
//  User.swift
//  Assignment3_WhatToEat
//
//  Created by Junhui Ye on 3/5/2025.
//

import FirebaseFirestore

struct User: Codable {
//    @DocumentID var id : String?
    let email: String
    let password: String
    let name: String
//    var favourites: [String] = []
}

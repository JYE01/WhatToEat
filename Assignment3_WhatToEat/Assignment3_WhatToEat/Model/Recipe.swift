//
//  Recipe.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 3/5/2025.
//

import FirebaseFirestore

struct Recipe: Identifiable, Codable{
    @DocumentID var id : String?
    var name : String
    var cuisine : String
    var ingredients : [String]
    var description : String
    var image : String
}


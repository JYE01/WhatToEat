//
//  IngredientModel.swift
//  Assignment3_WhatToEat
//
//  Created by Junhui Ye on 30/4/2025.
//

import Foundation
import FirebaseFirestore

struct Ingredient: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
}

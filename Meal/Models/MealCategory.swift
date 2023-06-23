//
//  Category.swift
//  Meal
//
//  Created by Iyin Raphael on 6/20/23.
//

import Foundation

struct MealCategory: Decodable {
    
    // MARK: - Properties
    let meals: [Meal]
}

struct Meal: Decodable, Hashable {
    
    // MARK: - Properties
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
}

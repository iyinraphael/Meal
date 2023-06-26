//
//  DetailViewModel.swift
//  Meal
//
//  Created by Iyin Raphael on 6/22/23.
//

import Foundation
import Combine

class DetailViewModel {
    
    // MARK: - Private Properties
    let apiService: APIService
    let mealID: String
   
    // MARK: - Public Properties
    /**
     Gets meal details with ID
     - Returns: A publisher that will return dictionary of meal deteails
     */
    public var mealDetails: AnyPublisher<[[String:String?]], APIServiceError> {
        return apiService
            .getMeal(.lookUpMealID, mealID)
            .map { $0.meals}.eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    init(apiService: APIService, mealID: String) {
        self.apiService = apiService
        self.mealID = mealID
    }
    
    func cleanIngredients(from meal: [String: String?]) -> String {
        var ingredientsArray = [String]()
        
        for num in 1...20 {
            if let ingredient = meal["strIngredient\(num)"],
               let measurement = meal["strMeasure\(num)"] {
                ingredientsArray.append("\(measurement ?? " ") \(ingredient ?? " ")")

            }
        }
        
        return ingredientsArray
            .filter { $0 != " " }
            .reduce("**********", { x, y in
                """
                \(x)
                \(y)
                """
            })
    }
}

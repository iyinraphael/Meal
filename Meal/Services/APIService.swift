//
//  APIService.swift
//  Meal
//
//  Created by Iyin Raphael on 6/21/23.
//

import Foundation
import Combine

protocol APIService: NetworkService {
    
    /**
     Gets meal details with ID
     - Returns: A publisher that will return MealDetails
     */
    func getMeal(_ environment: APIEnvironment.MealsURL, _ mealID: String) -> AnyPublisher<MealDetails, APIServiceError>
    
    /**
     Gets All available meals in a meal category
     - Returns: A publisher that will return MealCategory
     */
    func getMealInCategory(_ environment: APIEnvironment.MealsURL, _ category: String) -> AnyPublisher<MealCategory, APIServiceError>
}

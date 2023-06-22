//
//  MainViewModel.swift
//  Meal
//
//  Created by Iyin Raphael on 6/21/23.
//

import Foundation
import Combine

class MainViewModel {
    
    // MARK: - Private Properties
    private let apiService: MealAPIService

    private enum CategoryType: String {
        case starter = "Starter"
        case pasta = "Pasta"
        case dessert = "Dessert"
    }

    // MARK: - Public Properties
    
    /**
     Gets meal details with ID
     - Returns: A publisher that will return meal in stater category
     */
    public var starterMealCategoryPublisher: AnyPublisher<[Meal], APIServiceError> {
        return apiService
            .getMealInCategory(.filterCategory, CategoryType.starter.rawValue)
            .map { $0.meals }.eraseToAnyPublisher()
    }

    /**
     Gets meal in a category
     - Returns: A publisher that will return meal in pasta  category
     */
    public var pasterMealCategoryPublisher: AnyPublisher<[Meal], APIServiceError> {
        return apiService
            .getMealInCategory(.filterCategory, CategoryType.pasta.rawValue)
            .map { $0.meals }.eraseToAnyPublisher()
    }

    /**
     Gets meal in a category
     - Returns: A publisher that will return meal in dessert category
     */
    public var desertMealCategoryPublisher: AnyPublisher<[Meal], APIServiceError> {
        return apiService
            .getMealInCategory(.filterCategory, CategoryType.dessert.rawValue)
            .map { $0.meals }.eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    init(apiService: MealAPIService) {
        self.apiService = apiService
    }

}

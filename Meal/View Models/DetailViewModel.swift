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
   
    // MARK: - Public Properties

    /**
     Gets meal details with ID
     - Returns: A publisher that will return dictionary of meal deteails
     */
    public var mealDetails: AnyPublisher<[[String:String?]], APIServiceError> {
        return apiService
            .getMeal(.lookUpMealID, "52772")
            .map { $0.meals}.eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    init(apiService: APIService) {
        self.apiService = apiService
    }
}

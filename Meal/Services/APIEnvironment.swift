//
//  APIEnvironment.swift
//  Meal
//
//  Created by Iyin Raphael on 6/21/23.
//

import Foundation

struct APIEnvironment {
    
    // MARK - Private Properties
    private static let urlString = "https://themealdb.com/api/json/v1/1"
    
    // MARK - Public
    public enum MealsURL {
        case filterCategory
        case lookUpMealID
        
        var baseString: String {
            switch self {
            case .filterCategory:
                return "\(APIEnvironment.urlString)/filter.php"
            case .lookUpMealID:
                return "\(APIEnvironment.urlString)/lookup.php"
            }
        }
    }
}

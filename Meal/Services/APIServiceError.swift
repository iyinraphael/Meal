//
//  APIServiceError.swift
//  Meal
//
//  Created by Iyin Raphael on 6/20/23.
//

import Foundation

enum APIServiceError: Error {

    // MARK: - Error types
    case decodeFailure
    case networkFailure
    case generalFailure
    case noDataFailure
}

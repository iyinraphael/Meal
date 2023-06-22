//
//  MealAPIService.swift
//  Meal
//
//  Created by Iyin Raphael on 6/21/23.
//

import Foundation
import Combine

class MealAPIService {
    
    // MARK: - Private Properties
    private var urlSessionDataTask: URLSessionDataTask?
    private var urlSessionPublisherDataTask: URLSession.DataTaskPublisher?

    private let environmentAPI: APIEnvironment
    
    // MARK: - Initialize Struct

    init(environmentAPI: APIEnvironment) {
        self.environmentAPI = environmentAPI
    }
    
    // MARK: - Private Methods
    private func url(for parameters: [URLQueryItem], urlPath: String ) -> URL? {
        guard let baseURL = URL(string: urlPath) else { return nil }

        var urlComponent = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponent?.queryItems = parameters

        return urlComponent?.url
    }
}


extension MealAPIService: APIService {
    
    //MARK: - URLSession
    func getMeal(_ environment: APIEnvironment.MealsURL, _ mealID: String) -> AnyPublisher<MealDetails, APIServiceError> {
        let parameters = [URLQueryItem(name: "i", value: mealID)]
        let urlPath = environment.baseString
        
        guard let url = self.url(for: parameters, urlPath: urlPath) else {
            fatalError()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
                }
            .decode(type: MealDetails.self, decoder: JSONDecoder())
            .mapError { _ -> APIServiceError in
                return APIServiceError.networkFailure
            }
            .eraseToAnyPublisher()
        
    }
    
    func getMealInCategory(_ environment: APIEnvironment.MealsURL, _ category: String) -> AnyPublisher<MealCategory, APIServiceError> {
        let parameters = [URLQueryItem(name: "c", value: category)]
        let urlPath = environment.baseString

        guard let url = self.url(for: parameters, urlPath: urlPath) else {
            fatalError()
        }
    
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
                }
            .decode(type: MealCategory.self, decoder: JSONDecoder())
            .mapError { _ -> APIServiceError in
                return APIServiceError.networkFailure
            }
            .eraseToAnyPublisher()
    }
}

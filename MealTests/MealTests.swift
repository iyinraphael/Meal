//
//  MealTests.swift
//  MealTests
//
//  Created by Iyin Raphael on 6/20/23.
//

import XCTest
import Combine
@testable import Meal

final class MealTests: XCTestCase {
    
    let apiEnvironment =  APIEnvironment()
    var subscription: Set<AnyCancellable> = []
    var error: APIServiceError?
    
    func testDessetMeals() {
        let apiService = MealAPIService(environmentAPI: apiEnvironment)
        let sut = MainViewModel(apiService: apiService)
        let expectation  = XCTestExpectation(description: "all arrays received")
        
        var desserts = [Meal]()

        sut.desertMealCategoryPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
                expectation.fulfill()
            } receiveValue: { meal in
                desserts.append(contentsOf: meal)
            }.store(in: &subscription)

        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertTrue(desserts.count == 64)
    }
    
    func testStarterMeals() {
        let apiService = MealAPIService(environmentAPI: apiEnvironment)
        let sut = MainViewModel(apiService: apiService)
        let expectation  = XCTestExpectation(description: "all arrays received")
        
        var staters = [Meal]()

        sut.starterMealCategoryPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
                expectation.fulfill()
            } receiveValue: { meal in
                staters.append(contentsOf: meal)
            }.store(in: &subscription)
        

        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertTrue(staters.count == 4)
    }
    
    func testPastaMeals() {
        let apiService = MealAPIService(environmentAPI: apiEnvironment)
        let sut = MainViewModel(apiService: apiService)
        let expectation  = XCTestExpectation(description: "all arrays received")

        var pasta = [Meal]()

        sut.pastaMealCategoryPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                }
                expectation.fulfill()
            } receiveValue: { meal in
                pasta.append(contentsOf: meal)
            }.store(in: &subscription)
        

        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertTrue(pasta.count == 9)
    }
    
}

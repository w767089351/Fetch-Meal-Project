//
//  MealViewModelTests.swift
//  FetchMealTests
//
//  Created by WillWang on 2023-07-10.
//

import XCTest
import Combine

@testable import FetchMeal

class MealViewModelUITests: XCTestCase {

    var cancellables = Set<AnyCancellable>()
    func testLoadMeals() {
        let viewModel = MealViewModel()
        let expectation = XCTestExpectation(description: "Meals loaded")
        viewModel.$mealList
            .dropFirst()
            .sink { meals in
                XCTAssertFalse(meals.isEmpty, "Meals should not be empty")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        viewModel.loadMeals()
        wait(for: [expectation], timeout: 5.0)
    }

}

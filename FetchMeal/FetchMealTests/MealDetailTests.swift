//
//  MealDetailTests.swift
//  FetchMealTests
//
//  Created by WillWang on 2023-07-10.
//

import XCTest

@testable import FetchMeal

class MealDetailTests: XCTestCase {
    func testMealDetailDecoding() throws {

        let json = """
        {
            "meals": [
                {
                    "idMeal": "1",
                    "strMeal": "Pasta",
                    "strDrinkAlternate": null,
                    "strCategory": "Italian",
                    "strArea": "Italy",
                    "strInstructions": "Cook pasta...",
                    "strMealThumb": "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
                    "strTags": "pasta,italian,meal",
                    "strYoutube": "https://www.youtube.com/watch?v=123456",
                    "strSource": null,
                    "strImageSource": null,
                    "strCreativeCommonsConfirmed": "Yes",
                    "dateModified": "2021-01-01",
                    "strIngredient1": "Ingredient 1",
                    "strIngredient2": "Ingredient 2",
                    "strMeasure1": "Measurement 1",
                    "strMeasure2": "Measurement 2"
                }
            ]
        }
        """
        
        let data = json.data(using: .utf8)!

        let mealDetailJSON = try JSONDecoder().decode(MealDetailJSON.self, from: data)
        
        // Then
        XCTAssertEqual(mealDetailJSON.meals.count, 1)
        let mealDetail = mealDetailJSON.meals[0]
        XCTAssertEqual(mealDetail.id, "1")
        XCTAssertEqual(mealDetail.mealName, "Pasta")
        XCTAssertEqual(mealDetail.drinkAlternate, nil)
        XCTAssertEqual(mealDetail.category, "Italian")
        XCTAssertEqual(mealDetail.area, "Italy")
        XCTAssertEqual(mealDetail.instruction, "Cook pasta...")
        XCTAssertEqual(mealDetail.imageURL, "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg")
        XCTAssertEqual(mealDetail.tags, ["pasta", "italian", "meal"])
        XCTAssertEqual(mealDetail.youtubeURL, "https://www.youtube.com/watch?v=123456")
        XCTAssertEqual(mealDetail.sourseURL, nil)
        XCTAssertEqual(mealDetail.imageSource, nil)
        XCTAssertEqual(mealDetail.creativeCommonsConfirmed, "Yes")
        XCTAssertEqual(mealDetail.dateModified, "2021-01-01")
        XCTAssertEqual(mealDetail.ingredient, ["Ingredient 1", "Ingredient 2"])
        XCTAssertEqual(mealDetail.measure, ["Measurement 1", "Measurement 2"])
    }
    
}
    

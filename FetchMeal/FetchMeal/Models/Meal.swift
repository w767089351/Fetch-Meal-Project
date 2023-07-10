//
//  Meal.swift
//  FetchMeal
//
//  Created by WillWang on 2023-07-06.
//

import Foundation

struct MealJSON: Codable {
    let meals: [Meal]
    init(meals: [Meal] = []) {
        self.meals = meals
    }
}

struct Meal: Codable, Identifiable, Hashable {
    
    let id: String
    let mealName: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case mealName = "strMeal"
        case imageURL = "strMealThumb"
    }
    // we give mealName a default value "" if mealName does not exist in JSON data
    // we believe that id always exists and is unique
    init(id: String, mealName: String = "", imageURL: String) {
        self.id = id
        self.mealName = mealName
        self.imageURL = imageURL
    }
}

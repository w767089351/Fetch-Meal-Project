//
//  MealDetail.swift
//  FetchMeal
//
//  Created by WillWang on 2023-07-09.
//

import Foundation

struct MealDetailJSON: Codable {
    let meals: [MealDetail]
}

struct MealDetail: Codable {
    let id: String
    let mealName: String?
    let drinkAlternate: String?
    let category: String?
    let area: String?
    let instruction: String?
    let imageURL: String
    let tags: [String]?
    let youtubeURL: String?
    let sourseURL: String?
    let imageSource: String?
    let creativeCommonsConfirmed: String?
    let dateModified: String?
    let ingredient: [String]?
    let measure: [String]?

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case mealName = "strMeal"
        case drinkAlternate = "strDrinkAlternate"
        case category = "strCategory"
        case area = "strArea"
        case instruction = "strInstructions"
        case imageURL = "strMealThumb"
        case tags = "strTags"
        case youtubeURL = "strYoutube"
        case sourseURL = "strSource"
        case imageSource = "strImageSource"
        case creativeCommonsConfirmed = "strCreativeCommonsConfirmed"
        case dateModified = "dateModified"
    }
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }


    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        mealName = try container.decodeIfPresent(String.self, forKey: .mealName)
        drinkAlternate = try container.decodeIfPresent(String.self, forKey: .drinkAlternate)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        area = try container.decodeIfPresent(String.self, forKey: .area)
        instruction = try container.decodeIfPresent(String.self, forKey: .instruction)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        let tagString = try container.decodeIfPresent(String.self, forKey: .tags)
        if let string = tagString {
            tags = string.components(separatedBy: ",")
        } else {
            tags = nil
        }
        youtubeURL = try container.decodeIfPresent(String.self, forKey: .youtubeURL)
        sourseURL = try container.decodeIfPresent(String.self, forKey: .sourseURL)
        imageSource = try container.decodeIfPresent(String.self, forKey: .imageSource)
        creativeCommonsConfirmed = try container.decodeIfPresent(String.self, forKey: .creativeCommonsConfirmed)
        dateModified = try container.decodeIfPresent(String.self, forKey: .dateModified)
        
        var ingredients: [String] = []
        var measures: [String] = []
        
        let containerDynamic = try decoder.container(keyedBy: DynamicCodingKeys.self)

        for key in containerDynamic.allKeys {
            if key.stringValue.hasPrefix("strIngredient"), let ingredient = try containerDynamic.decodeIfPresent(String.self, forKey: key), !ingredient.isEmpty {
                ingredients.append(ingredient)
            }

            if key.stringValue.hasPrefix("strMeasure"), let measure = try containerDynamic.decodeIfPresent(String.self, forKey: key), !measure.isEmpty {
                measures.append(measure)
            }
        }
        ingredient = ingredients
        measure = measures
    }
}

//
//  IngredientView.swift
//  FetchMeal
//
//  Created by WillWang on 2023-07-10.
//

import Foundation
import SwiftUI

struct IngredientView : View {
    @EnvironmentObject var mealDetail: MealDetailViewModel
    var body: some View {
        Text("Ingredient:").bold()
        if let ingredient = mealDetail.mealDetailInfo?.ingredient, let measure = mealDetail.mealDetailInfo?.measure {
            ForEach(0..<min(ingredient.count, measure.count), id: \.self) { index in
                let measureValue = measure[index]
                Text("\(ingredient[index]): \(measureValue == " " ? "Depends" : measureValue)")
            }
        }
    }
}

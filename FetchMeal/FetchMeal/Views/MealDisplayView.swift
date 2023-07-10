//
//  MealDisplayView.swift
//  FetchMeal
//
//  Created by WillWang on 2023-07-09.
//


import Foundation
import SwiftUI

struct MealDisplayView : View {
    let meal: Meal
    @State var active: Bool = false
    var body: some View {
        HStack {
            NavigationLink(destination: MealDetailView(id: meal.id), isActive: $active) { EmptyView() }
                .frame(width: 0, height: 0)
                .hidden()
            ImageView(imageURL: meal.imageURL, width: 65, height: 65)
            Text(meal.mealName)
        }
        .onTapGesture {
            active = true
        }
    }
}

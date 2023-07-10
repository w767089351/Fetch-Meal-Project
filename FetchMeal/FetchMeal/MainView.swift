//
//  MainView.swift
//  FetchMeal
//
//  Created by WillWang on 2023-07-05.
//

import SwiftUI
import AVKit

struct MainView: View {
    
    @StateObject var meals = MealViewModel()
    @State var action: String = ""
    @State var ss: Bool = true
   
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach (meals.mealList, id: \.self) { meal in
                        MealDisplayView(meal: meal)
                    }
                }
                .onAppear() {
                    meals.loadMeals()
                }
            }
            .padding()
        }
    }
}


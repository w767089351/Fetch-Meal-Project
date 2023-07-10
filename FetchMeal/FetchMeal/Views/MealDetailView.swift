//
//  MealDetailView.swift
//  FetchMeal
//
//  Created by WillWang on 2023-07-09.
//

import Foundation
import SwiftUI

struct MealDetailView : View {
    let id: String
    @StateObject var mealDetail = MealDetailViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    Spacer()
                }
            }
            .overlay (
                HStack(alignment: .center) {
                    Text(mealDetail.mealDetailInfo?.mealName ?? "Unknown")
                        .font(.title)
                        .bold()
                }
            )
            .zIndex(1)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .center) {
                        Spacer()
                        if let imageURL = mealDetail.mealDetailInfo?.imageURL, !imageURL.isEmpty {
                            ImageView(imageURL: imageURL, width: 200, height: 200)
                        } else {
                            Color.gray.frame(width: 200, height: 200).cornerRadius(8)
                        }
                        Spacer()
                    }
                        
                    Group {
                        Text("Drink Alternate: ").bold() + Text(mealDetail.mealDetailInfo?.drinkAlternate ?? "None")
                        Text("Category: ").bold() + Text(mealDetail.mealDetailInfo?.category ?? "None")
                        Text("Area: ").bold() + Text(mealDetail.mealDetailInfo?.area ?? "None")
                        Text("Instruction: ").bold() + Text(mealDetail.mealDetailInfo?.instruction ?? "None")
                        Text("Tags: ").bold() + Text(mealDetail.mealDetailInfo?.tags?.joined(separator: ", ") ?? "None")
                            
                        Text("Creative Commons Confirmed: ").bold() + Text(mealDetail.mealDetailInfo?.creativeCommonsConfirmed ?? "None")
                        Text("Date Modified: ").bold() + Text(mealDetail.mealDetailInfo?.dateModified ?? "None")
                    }
                    
                    IngredientView().environmentObject(mealDetail)
                }
            }
            .onAppear() {
                mealDetail.loadMeals(id: id)
            }.navigationBarHidden(true)
            .padding()
        }
        .zIndex(0)
    }
}


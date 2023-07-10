//
//  MealViewModel.swift
//  FetchMeal
//
//  Created by WillWang on 2023-07-06.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case missingKey
}

class MealViewModel: ObservableObject {
    @Published var mealList = [Meal]()
    let decoder = JSONDecoder()
    var pub: AnyPublisher<(data: [Meal], response: URLResponse), NetworkError>? = nil
    var sub: Cancellable? = nil
    
    func fetchDataFromAPI() -> AnyPublisher<(data: [Meal], response: URLResponse), NetworkError> {
        
        guard let urls: String = Bundle.main.infoDictionary?["MEAL_LIST_URL"] as? String else {
            return Fail(error: NetworkError.missingKey).eraseToAnyPublisher()
        }
        
        guard let url = URL(string: urls) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        let request = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.requestFailed
                }
                let decodedMeal = try self.decoder.decode(MealJSON.self, from: data)
                let sortedMeals = decodedMeal.meals.sorted { $0.mealName < $1.mealName }
                return (sortedMeals, response)
            }
            .mapError { error -> NetworkError in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.decodingFailed
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func loadMeals() {
        pub = fetchDataFromAPI()
        sub = pub?.sink { completion in
                switch completion {
                case .finished:
                    print("Request completed successfully")
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            } receiveValue: { data, response in
                self.mealList = data
            }
        return
    }
}




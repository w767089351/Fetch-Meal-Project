//
//  MealDetailViewModel.swift
//  FetchMeal
//
//  Created by WillWang on 2023-07-09.
//

import Foundation
import Combine

class MealDetailViewModel: ObservableObject {

    let decoder = JSONDecoder()
    @Published var mealDetailInfo: MealDetail?
    var pub: AnyPublisher<(data: [MealDetail], response: URLResponse), NetworkError>? = nil
    var sub: Cancellable? = nil
    
    func fetchDataFromAPI(id: String) -> AnyPublisher<(data: [MealDetail], response: URLResponse), NetworkError> {
        
        guard let urls: String = (Bundle.main.infoDictionary?["MEAL_DETAIL_URL"]) as? String else {
            return Fail(error: NetworkError.missingKey).eraseToAnyPublisher()
        }
        
        guard let url = URL(string: urls + id) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        let request = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.requestFailed
                }
                let decodedMeal = try self.decoder.decode(MealDetailJSON.self, from: data)
                return (decodedMeal.meals, response)
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
    
    
    func loadMeals(id: String) {
        pub = fetchDataFromAPI(id: id)
        sub = pub?.sink { completion in
                switch completion {
                case .finished:
                    print("Request completed successfully")
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            } receiveValue: { data, response in
                self.mealDetailInfo = data[0]
            }
        return
    }
}




//
//  ImageView.swift
//  FetchMeal
//
//  Created by WillWang on 2023-07-07.
//

import SwiftUI
import Combine
import UIKit

extension UIImageView {
    private static let imageCache = NSCache<NSString, UIImage>()

    func loadImage(from url: URL, placeholder: UIImage? = nil) -> AnyPublisher<UIImage?, Never> {
        self.image = placeholder
        
        if let cachedImage = UIImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return Just(cachedImage)
                .setFailureType(to: Never.self)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .compactMap { UIImage(data: $0) }
            .replaceError(with: nil)
            .map { image in
                guard let image = image else { return nil }
                UIImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                return image
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct ImageView: View {
    let imageURL: String
    let width: CGFloat
    let height: CGFloat
    @StateObject var imageLoader = ImageLoader()

    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .cornerRadius(8)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            imageLoader.loadImage(from: URL(string: imageURL)!)
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    var cancellable: AnyCancellable?

    func loadImage(from url: URL) {
        cancellable = UIImageView().loadImage(from: url)
            .sink { [weak self] image in
                self?.image = image
            }
    }
}

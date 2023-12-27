//
//  ImageLoader.swift
//  Challenge
//
//  Created by Mehedi Hasan on 5/2/20.
//

import UIKit

final class ImageLoader {
    private static let CHACHE_FILE_NAME = "app.image"
    private static let imageCache = Cache<String, ImageWrapper>(withName: ImageLoader.CHACHE_FILE_NAME,
                                                                entryLifetime: 30*24*60*60,
                                                                maximumEntryCount: 300)
    
    
    private static func downloadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }
        dataTask.resume()
    }
    
    static func loadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
        if let imageWrapper = imageCache.value(for: url.absoluteString) {
            completion(imageWrapper.image)
            return
        }
        
        downloadImage(with: url) { downloadedImage in
            guard let image = downloadedImage else {
                completion(nil)
                return
            }
            completion(image)
            imageCache.insert(ImageWrapper(image: image), for: url.absoluteString)
            try? imageCache.saveToDisk(withName: CHACHE_FILE_NAME)
        }
    }
}

private extension ImageLoader {
    enum DecodingError: Error {
        case decodingFailed
    }
    
    struct ImageWrapper: Codable {
        let image: UIImage
        enum CodingKeys: String, CodingKey {
            case image
        }
        
        init(image: UIImage) {
            self.image = image
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let data = try container.decode(Data.self, forKey: CodingKeys.image)
            guard let image = UIImage(data: data) else {
                throw DecodingError.decodingFailed
            }
            
            self.image = image
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            guard let data = self.image.pngData() else {
                return
            }
            try container.encode(data, forKey: CodingKeys.image)
        }
    }
}

//MARK: - UIImageView Additions

extension UIImageView {
    
    func setImage(withURL url: URL, placeholderImage: UIImage? = nil, showHud: Bool = false) {
        if showHud {
            showHudLoader()
        }
        
        if let placeholderImage = placeholderImage { self.image = placeholderImage }
        
        ImageLoader.loadImage(with: url) { [weak self] image in
            DispatchQueue.main.async {
                if showHud {
                    self?.hideHudLoader()
                }
                self?.image = image
            }
        }
    }
}


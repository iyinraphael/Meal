//
//  ImageLoader.swift
//  Meal
//
//  Created by Iyin Raphael on 6/25/23.
//

import UIKit

class ImageLoader {
    
    static func downloadImageFrom(imageStr: String, imageView: UIImageView) {
        let imageCache = NSCache<NSString, AnyObject>()

        if let cachedImage = imageCache.object(
            forKey: imageStr as NSString) as?  UIImage {
            imageView.image = cachedImage
            
        }else {
            guard let imageURL = URL(string: imageStr) else { fatalError()}
            
            URLSession.shared.dataTask(with: imageURL) { data, _, _ in
                guard let data = data, let imageToCache = UIImage(data: data)
                else { fatalError("could not retrieve image")}
                
                imageCache.setObject(imageToCache, forKey: imageStr as NSString)
                
                DispatchQueue.main.async {
                    imageView.image = imageToCache
                }
            }.resume()
        }
    }

}


extension UIImageView {
    
    func loadImage(from urlString: String) {
        ImageLoader.downloadImageFrom(imageStr: urlString, imageView: self)
    }
}

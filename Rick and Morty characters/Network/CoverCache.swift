import UIKit

class CoverCache {
    
    static let shared = CoverCache()

    private let imageCache = NSCache<NSString, UIImage>()

    func save(url: String, image: UIImage) {
        imageCache.setObject(image, forKey: url as NSString)
    }

    func getImage(url: String) -> UIImage? {
        imageCache.object(forKey: url as NSString)
    }

}

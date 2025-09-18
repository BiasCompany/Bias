import Foundation
import Kingfisher
import SwiftUI

class ImageManager {
    /// Creates a Kingfisher image view with advanced configuration
    /// - Parameters:
    ///   - url: The URL of the image to load
    ///   - placeholder: Optional placeholder image    
    /// - Returns: A configured KFImage
    @MainActor static func loadImage(
        url: URL?,
        placeholder: Image? = Image(systemName: "photo")
    ) -> some View {
        KFImage(url)
            .placeholder {
                ProgressView()
            }
            .setProcessor(DefaultImageProcessor())
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .resizable()
            .scaledToFit()
    }
    
    /// Preload image to cache
    /// - Parameter url: URL of the image to preload
    static func preloadImage(url: URL?) {
        guard let url = url else { return }
        
        KingfisherManager.shared.retrieveImage(with: url) { _ in
            // Image preloaded to cache
        }
    }
    
    /// Clear image cache
    static func clearCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }
}

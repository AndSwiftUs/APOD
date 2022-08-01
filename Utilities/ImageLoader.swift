import UIKit
import Combine

final class ImageLoader {
    func loadImage(from url: String) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map { (data, _) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

import Foundation
import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .compactMap { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }
}

extension UIImageView {
    func loadImageFromURL(imageUrlString: String) {
        
        CAVProgressHud.sharedInstance.show(withTitle: "Loading image from NASA...")
        
        guard let imageUrl = URL(string: imageUrlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.image = image
                        
                        CAVProgressHud.sharedInstance.hide()
                    }
                }
            }
        }
    }
}

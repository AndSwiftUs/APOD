import Foundation
import Combine
import UIKit

final class APODsCellViewModel {
    @Published var apodDate: String = ""
    @Published var apodTile: String = ""
    @Published var apodImage = UIImage()
        
    private let apod: APOD
    
    init(apod: APOD, apodImage: UIImage) {
        self.apod = apod
        self.apodImage = apodImage
        setUpBindings()
    }
    
    private func setUpBindings() {
        apodDate = apod.date
        apodTile = apod.title
    }
}

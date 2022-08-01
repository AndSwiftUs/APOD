import Foundation
import UIKit
import Combine

final class FavoritesTableViewCellViewModel {
    
    @Published var apodDate: String = ""
    @Published var apodTile: String = ""
    @Published var apodImage = UIImage()
        
    private let apod: APODInstance
    
    init(apod: APODInstance) {
        self.apod = apod
        setUpBindings()
    }
    
    private func setUpBindings() {
        apodDate = apod.date!
        apodTile = apod.title!
        apodImage = UIImage(data: apod.imageData!)!
    }
}

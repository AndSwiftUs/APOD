import Foundation
import Combine

final class APODsCellViewModel {
    @Published var apodDate: String = ""
    @Published var apodTile: String = ""
        
    private let apod: APOD
    
    init(apod: APOD) {
        self.apod = apod
        
        setUpBindings()
    }
    
    private func setUpBindings() {
        apodDate = apod.date
        apodTile = apod.title
    }
}

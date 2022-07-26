import Foundation
import Combine

class FavouritesViewModel {
        
    @Published var APODsArray: [APODInstance] = []
    
    private var bindings = Set<AnyCancellable>()

    func fetchAllFavourites() {
        APODsArray = MainStorageManager.shared.getAllItemsReversed()
        return
    }
    
}

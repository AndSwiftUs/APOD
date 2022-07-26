import Foundation
import Combine
import UIKit
import SwiftUI

final class SearchViewModel {
    
    private let networkingManager = NetworkingManager()
    
    enum Section { case apods }
    
    @Published private(set) var apods: [APOD] = [] {
        didSet { cacheAPODsImages() }
    }
    @Published private(set) var dictionaryImageCache: Dictionary<String, UIImage> = [String:UIImage]()
    
    private var bindings = Set<AnyCancellable>()
    
    func searchRandomAPODs(count: Int) {
        
        CAVProgressHud.sharedInstance.show(withTitle: "Loading data from NASA...")
        
        guard let url = URL(string: "\(AppConstants.NASA.defaultNASAUrl)?count=\(count)&api_key=\(AppConstants.NASA.myAPIKEY)") else { return }
        
        let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)
        
        dataTaskPublisher
            .retry(1)
            .map { $0.data }
            .decode(type: [APOD].self, decoder: JSONDecoder() )
            .replaceError(with: [APOD(date: "Error",
                                      explanation: "No Internet connection",
                                      media_type: "",
                                      service_version: "",
                                      title: "No Internet connection",
                                      url: "")])
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { data in
                self.apods = data
                CAVProgressHud.sharedInstance.hide()
            })
            .store(in: &bindings)
    }
    
    func cacheAPODsImages() {
        apods.forEach { apod in
            
            if (dictionaryImageCache[apod.url] == nil) {
                
                guard let url = URL(string: apod.hdurl ?? apod.url) else { return }
                
                URLSession.shared.dataTaskPublisher(for: url)
                    .map { UIImage(data: $0.data) }
                    .replaceError(with: UIImage(named: "nasa-logo"))
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: { image in
                        self.dictionaryImageCache[apod.url] = image
                        if AppConstants.debug { print(#function, "APOD image load from: ", apod.url, " ", image?.size ?? "no image") }
                    })
                    .store(in: &bindings)
            }
        }
    }
    
    func getAPODsForDate(date: String) -> APOD {
        print(#function, date)
        
        CAVProgressHud.sharedInstance.show(withTitle: "Loading data from NASA...")
        
        var fetchedAPOD = APOD(copyright: "error", date: "error", explanation: "error", hdurl: "error", media_type: "error", service_version: "error", title: date, url: "error")
        
        
        networkingManager.request(endpoint: NasaInstanceOfTheDayAPI.nasa) { (result: Result<APOD, NetworkingError>) in
            
            switch result {
            case .success(let apod):
                fetchedAPOD = apod
            case .failure(let error):
                print((error.localizedDescription))
            }
        }
        
        CAVProgressHud.sharedInstance.hide()
        
        return fetchedAPOD
    }
    
}

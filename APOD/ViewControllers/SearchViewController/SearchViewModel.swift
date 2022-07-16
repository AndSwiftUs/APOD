import Foundation
import Combine
import UIKit
import SwiftUI

final class SearchViewModel {
    
    enum Section { case apods }
    
    @Published private(set) var apods: [APOD] = [] {
        didSet { cacheAPODsImages() }
    }
    @Published private(set) var dictionaryImageCache: Dictionary<String, UIImage> = [String:UIImage]()
    
    private var bindings = Set<AnyCancellable>()
    
    func searchRandomAPODs() {
        
        CAVProgressHud.sharedInstance.show(withTitle: "Loading data from NASA...")
        
        let defaultCount = 8
        
        let dataTaskPublisher = URLSession.shared.dataTaskPublisher(
            for: URL(string: "https://api.nasa.gov/planetary/apod?count=\(defaultCount)&api_key=58EbYM2UDKh8ovgnnbwtoBBqJSGpANHhQ78Xbuds")!)
        
        dataTaskPublisher
        //            .retry(1)
            .map { $0.data }
            .decode(type: [APOD].self, decoder: JSONDecoder() )
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { data in
                print(#function, data)
                self.apods = data
                CAVProgressHud.sharedInstance.hide()
            })
            .store(in: &bindings)
        
        print(#function)
    }
    
    func cacheAPODsImages() {
        print(#function, " Start")
        apods.forEach { apod in
            
            if (dictionaryImageCache[apod.url] == nil) {
                
                guard let url = URL(string: //apod.hdurl ??
                                    apod.url) else { return }
                
                URLSession.shared.dataTaskPublisher(for: url)
                    .map { UIImage(data: $0.data) }
                    .replaceError(with: UIImage(named: "nasa-logo"))
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: { image in
                        self.dictionaryImageCache[apod.url] = image
                        print(#function, "APOD image load from: ", apod.url, " ", image?.size)
                    })
                    .store(in: &bindings)
            }
        }
    }
    
    func searchAPODsForName(name: String) {
        print(#function, name)
    }
    
}

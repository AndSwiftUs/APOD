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
        
        let dataTaskPublisher = URLSession.shared.dataTaskPublisher(
            for: URL(string: "https://api.nasa.gov/planetary/apod?count=\(AppConstants.defaultCountOfRandomAPODs)&api_key=\(AppConstants.NASA.myAPIKEY)")!)
        
        dataTaskPublisher
            .retry(1)
            .map { $0.data }
            .decode(type: [APOD].self, decoder: JSONDecoder() )
            .replaceError(with: [APOD(date: "Error", explanation: "No Internet connection", media_type: "", service_version: "", title: "No Internet connection", url: "")])
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { data in
//                print(#function, data)
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
                                    apod.url)
                else { return }
                
                URLSession.shared.dataTaskPublisher(for: url)
                    .map { UIImage(data: $0.data) }
                    .replaceError(with: UIImage(named: "nasa-logo"))
                    .receive(on: DispatchQueue.main)
                    .sink(receiveValue: { image in
                        self.dictionaryImageCache[apod.url] = image
                        print(#function, "APOD image load from: ", apod.url, " ", image?.size ?? "no image")
                    })
                    .store(in: &bindings)
            }
        }
    }
    
    func searchAPODsForName(name: String) {
        print(#function, name)
    }
    
}

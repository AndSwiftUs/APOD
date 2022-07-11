import Foundation
import Combine

final class SearchViewModel {
    
    enum Section { case apods }
    
    @Published private(set) var apods: [APOD] = []
    
    private var bindings = Set<AnyCancellable>()
    
    func searchRandomAPODs() {
        let defaultCount = 20
        
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
            })
            .store(in: &bindings)
        
        print(#function)
    }
    
    func searchAPODsForName(name: String) {
        print(#function, name)
    }
    
}

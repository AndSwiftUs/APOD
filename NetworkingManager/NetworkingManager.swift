import Foundation

class NetworkingManager {
    private func buildURL(endpoind: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoind.scheme.rawValue
        components.host = endpoind.baseURL
        components.path = endpoind.path
        components.queryItems = endpoind.parameters
        return components
    }
    
    func request<T: Decodable>(endpoint: API, completion: @escaping (Result<T, NetworkingError>) -> Void) {
        let component = buildURL(endpoind: endpoint)
                
        guard let url = component.url else {
            completion(.failure(.invalidURL))
            return
        }
                
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        
        let session = URLSession(configuration: .default)
                
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
            else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
                      
            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(responseObject))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        dataTask.resume()
        CAVProgressHud.sharedInstance.hide()
    }
}

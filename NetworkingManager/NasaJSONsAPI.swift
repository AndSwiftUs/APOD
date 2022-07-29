import Foundation

enum NasaJSONsAPI: API {
    
    case nasa
    
    var scheme: HTTPScheme {
        return .https
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var baseURL: String {
        return AppConstants.NASA.baseURLDomain
    }
    
    var path: String {
        return AppConstants.NASA.baseURLPath
    }
    
    var parameters: [URLQueryItem] {
        return [URLQueryItem(name: "count", value: "12"),
                URLQueryItem(name: "api_key", value: Prefs.shared.userAPIKey)
        ]
    }
}

import Foundation

protocol API {
    // .http or .https
    var scheme: HTTPScheme { get }
    // GET
    var method: HTTPMethod { get }
    // google.com
    var baseURL: String { get }
    // privacy
    var path: String { get }
    // query items
    var parameters: [URLQueryItem] { get }
}

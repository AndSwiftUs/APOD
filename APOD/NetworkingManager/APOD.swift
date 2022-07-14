import UIKit

public struct APOD: Codable, Hashable {
    var copyright: String?
    var date: String
    var explanation: String
    var hdurl: String?
    var media_type: String
    var service_version: String
    var title: String
    var url: String
}

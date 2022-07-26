import Foundation
import UIKit

struct AppConstants {
    
    static let debug = true
    
    static let defaultCountOfRandomAPODs    = 6
    
    static let defaultThinPaggin      = CGFloat( 4 )
    static let defaultPaggin          = CGFloat( 16 )

    struct ViewControllers {
        
        struct SearchVC {
            static let title = "Search"
            static let image = "magnifyingglass"
            static let bgColor = UIColor.systemGray6
            static let largeTitles = true
        }
        
        struct FavouritesVC {
            static let title = "Favourites"
            static let image = "star"
            static let bgColor = UIColor.systemGray6
            static let largeTitles = true
        }
        
        struct CentralVC {
            static let title = "Picture of the Day"
            static let image = "person"
            static let bgColor = UIColor.systemGray6
            static let largeTitles = false
        }
        
        struct AboutVC {
            static let title = "About"
            static let image = "info.circle"
            static let bgColor = UIColor.systemGray6
            static let largeTitles = true
        }
        
        struct SettingsVC {
            static let title = "Settings"
            static let image = "gear"
            static let bgColor = UIColor.systemGray6
            static let largeTitles = true
        }
    }
    
    struct NASA {
        static let defaultAPIKey = "DEMO_KEY"
        static let defaultNASAUrl = "https://api.nasa.gov/planetary/apod"
        static let myAPIKEY = "58EbYM2UDKh8ovgnnbwtoBBqJSGpANHhQ78Xbuds"
        
        static let baseURLScheme = HTTPScheme.https
        static let baseURLMethod = HTTPMethod.get
        static let baseURLDomain = "api.nasa.gov"
        static let baseURLPath = "/planetary/apod"
        
        struct URLs {
            static let defaultAPODurl = "https://api.nasa.gov/planetary/apod?api_key=58EbYM2UDKh8ovgnnbwtoBBqJSGpANHhQ78Xbuds"
            static let testAPODImageURL = "https://apod.nasa.gov/apod/image/2205/RCW86_MP1024.jpg"
            static let testAPODImageHDURL = "https://apod.nasa.gov/apod/image/2205/RCW86_MP.jpg"
        }
    }
}

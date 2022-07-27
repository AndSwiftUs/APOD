import Foundation

class Prefs {
    private let defaults = UserDefaults.standard
    
    private let isNotFirstLaunchKey = "isNotFirstLaunch"
    var isNotFirstLaunch: Bool {
        set { defaults.setValue(newValue, forKey: isNotFirstLaunchKey) }
        get { return defaults.bool(forKey: isNotFirstLaunchKey) }
    }
    
    private let userAPIKeyKey = "userAPIKey"
    var userAPIKey: String {
        set { defaults.setValue(newValue, forKey: userAPIKeyKey) }
        get { return defaults.string(forKey: userAPIKeyKey) ?? AppConstants.NASA.defaultAPIKey }
    }
    
    class var shared: Prefs {
        struct Static {
            static let instance = Prefs()
        }
        
        return Static.instance
    }
}

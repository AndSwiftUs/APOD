import Foundation

class Prefs {
    private let defaults = UserDefaults.standard
    
    static let shared = Prefs()
    
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
}

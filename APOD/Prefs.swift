import Foundation

class Prefs {
    private let defaults = UserDefaults.standard
    
    private let isNotFirstLaunchKey = "isFirstLaunch"
    
    var isNotFirstLaunch: Bool {
        set {
            defaults.setValue(newValue, forKey: isNotFirstLaunchKey)
        }
        get {
            return defaults.bool(forKey: isNotFirstLaunchKey)
        }
    }
    
    class var shared: Prefs {
        struct Static {
            static let instance = Prefs()
        }
        
        return Static.instance
    }
}

import UIKit

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.ViewControllers.SettingsVC.bgColor
        title = AppConstants.ViewControllers.SettingsVC.title
        self.navigationController?.navigationBar.prefersLargeTitles = AppConstants.ViewControllers.SettingsVC.largeTitles

    }
}

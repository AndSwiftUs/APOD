import UIKit

class SearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.ViewControllers.SearchVC.bgColor
        title = AppConstants.ViewControllers.SearchVC.title
        self.navigationController?.navigationBar.prefersLargeTitles = AppConstants.ViewControllers.SearchVC.largeTitles
    }
}

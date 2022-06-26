import UIKit

class AboutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.ViewControllers.AboutVC.bgColor
        title = AppConstants.ViewControllers.AboutVC.title
        self.navigationController?.navigationBar.prefersLargeTitles = AppConstants.ViewControllers.AboutVC.largeTitles

    }
}

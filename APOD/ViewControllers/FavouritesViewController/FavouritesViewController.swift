import UIKit

class FavouritesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.ViewControllers.FavouritesVC.bgColor
        title = AppConstants.ViewControllers.FavouritesVC.title
        self.navigationController?.navigationBar.prefersLargeTitles = AppConstants.ViewControllers.FavouritesVC.largeTitles

    }
}

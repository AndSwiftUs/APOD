import UIKit

class CentralViewController: UIViewController {
    
    private let networkingManager = NetworkingManager()
    private lazy var contentView = APODView()
    
    private var currentAPOD:APOD? = nil {
        didSet {
            DispatchQueue.main.async {
                guard let title = self.currentAPOD?.title,
                      //                      let url = self.currentAPOD?.url,
                      let explanation = self.currentAPOD?.explanation
                else { return }
                
                self.contentView.imageNameLabel.text = "\(title)"
                
                if let copyright = self.currentAPOD?.copyright {
                    self.contentView.imageTextLabel.text = "Copyright: \(copyright)\n\n\(explanation)"
                } else {
                    self.contentView.imageTextLabel.text = "\(explanation)"
                }
                
                self.fetchImageFromCurrentInstance()
                
            }
        }
    }
    
    override func loadView() {
        view = contentView
    }
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.ViewControllers.CentralVC.bgColor
        title = AppConstants.ViewControllers.CentralVC.title
        self.navigationController?.navigationBar.prefersLargeTitles = AppConstants.ViewControllers.CentralVC.largeTitles
        
        CAVProgressHud.sharedInstance.show(withTitle: "Loading data from NASA...")
        
        fetchInstanceOfTheDayWithNetworkingManager()
    }
    
    func fetchImageFromCurrentInstance() {
        guard currentAPOD?.media_type == "image",
              let url = //currentAPOD?.hdurl ??
                currentAPOD?.url
        else { return }
        
        //debug
        if AppConstants.debug { print(#function, "trying get image ", String(describing: currentAPOD?.date), " from: ", url) }
        
        contentView.imageView.loadImageFromURL(imageUrlString: url)
    }
    
    func fetchInstanceOfTheDayWithNetworkingManager() {
        networkingManager.request(endpoint: NasaInstanceOfTheDayAPI.nasa) { (result: Result<APOD, NetworkingError>) in
            
            switch result {
            case .success(let apod):
                self.currentAPOD = apod
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(error: error.rawValue)
                }
            }
        }
    }
    
    func showAlert(error: String) {
        CAVProgressHud.sharedInstance.hide()
        let alert = UIAlertController(
            title: "Error loading data:\n",
            message: error,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) {_ in
            self.contentView.imageNameLabel.text = "\nTry pull to refresh"
            return
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

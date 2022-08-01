import UIKit

class CentralViewController: UIViewController {
    
    private let networkingManager = NetworkingManager()
    private let storageManager: MainStorageManager
    private lazy var contentView = APODView()
    
    private lazy var favouriteButton = UIBarButtonItem(image: UIImage(systemName: "star"),
                                                       style: .done,
                                                       target: self,
                                                       action: #selector(favouriteButtonTapped))
    private var isFavourite: Bool = false {
        didSet { favouriteButton.image = UIImage(systemName: isFavourite ? "star.fill" : "star") }
    }
    
    @objc func favouriteButtonTapped() {
        if !isFavourite {
            storageManager.saveItem(with: currentAPOD!, apodImage: contentView.imageView.image!) { error in
                self.contentView.imageView.image = UIImage(named: "nasa-logo-error-connection")
            }
            isFavourite = true
        }
    }
    
    private var currentAPOD:APOD? = nil {
        didSet {
            DispatchQueue.main.async {
                guard let title = self.currentAPOD?.title,
                      // let url = self.currentAPOD?.url,
                      let explanation = self.currentAPOD?.explanation
                else { return }
                
                self.contentView.imageNameLabel.text = "\(title)"
                
                if let copyright = self.currentAPOD?.copyright {
                    self.contentView.imageTextLabel.text = "Copyright: \(copyright)\n\n\(explanation)"
                } else {
                    self.contentView.imageTextLabel.text = explanation
                }
                
                self.fetchImageFromCurrentInstance()
            }
        }
    }
    
    init(storeManager: MainStorageManager) {
        self.storageManager = storeManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
        navigationItem.rightBarButtonItem = favouriteButton
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
        
        contentView.imageView.loadImageFromURL(imageUrlString: url)
    }
    
    func fetchInstanceOfTheDayWithNetworkingManager() {
        networkingManager.request(endpoint: NasaInstanceOfTheDayAPI.nasa) { (result: Result<APOD, NetworkingError>) in
            switch result {
            case .success(let apod):
                self.currentAPOD = apod
            case .failure(let error):
                DispatchQueue.main.async {
                    self.contentView.imageView.image = UIImage(named: "nasa-logo-error-connection")
                    self.contentView.imageTextLabel.text = error.rawValue
                }
            }
        }
    }
}

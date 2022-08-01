import UIKit
import Combine

class DetailsViewController: UIViewController {
    
    private var apod: APOD?
    private var apodImage: UIImage?
    
    private let storageManager: MainStorageManager
    
    private lazy var favouriteButton = UIBarButtonItem(image: UIImage(systemName: "star"),
                                                       style: .done,
                                                       target: self,
                                                       action: #selector(favouriteButtonTapped))
    private var isFavourite: Bool = false {
        didSet { favouriteButton.image = UIImage(systemName: isFavourite ? "star.fill" : "star") }
    }
    
    @objc func favouriteButtonTapped() {
        
        if !isFavourite {
            
            CAVProgressHud.sharedInstance.show(withTitle: "Save data from NASA...")
            
            guard let apod = apod,
                  let apodImage = apodImage
            else { return }
            
            storageManager.saveItem(with: apod, apodImage: apodImage) { error in
                self.contentView.imageView.image = UIImage(named: "nasa-logo-error-connection")
            }
            
            isFavourite = true

        } else {
            
        }
        
        CAVProgressHud.sharedInstance.hide()
    }
    
    private lazy var contentView = APODView()
    
    init(storageManager: MainStorageManager, apod: APOD, apodImage: UIImage) {
        self.storageManager = storageManager
        self.apod = apod
        self.apodImage = apodImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
        navigationItem.rightBarButtonItem = favouriteButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppConstants.ViewControllers.SearchVC.bgColor
        contentView.imageNameLabel.text = apod?.title
        contentView.imageTextLabel.text = apod?.explanation
        contentView.imageView.image = apodImage
    }
}

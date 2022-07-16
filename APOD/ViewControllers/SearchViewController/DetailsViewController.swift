import UIKit
import Combine

class DetailsViewController: UIViewController {
    
    private var apod: APOD?
    private var apodImage: UIImage?
    
    private lazy var contentView = APODView()
    
    init(apod: APOD, apodImage: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.apod = apod
        self.apodImage = apodImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppConstants.ViewControllers.SearchVC.bgColor
        contentView.imageNameLabel.text = apod?.title
        contentView.imageTextLabel.text = apod?.explanation
        contentView.imageView.image = apodImage
    }
    
    
}

import UIKit

class CentralViewController: UIViewController {
    
    private let imageZoomableScrollingView = UIScrollView()
    private let imageView = UIImageView()
    private let imageNameLabel = UILabel()
    private let imageTextScrollingView = UIScrollView()
    private let imageTextLabel = UILabel()
    private let networkingManager = NetworkingManager()
    
    private var currentAPOD:APOD? = nil {
        didSet {
            DispatchQueue.main.async {
                guard let title = self.currentAPOD?.title,
//                      let url = self.currentAPOD?.url,
                      let explanation = self.currentAPOD?.explanation
                else { return }
                
                self.imageNameLabel.text = "\(title)\n"
                
                if let copyright = self.currentAPOD?.copyright {
                    self.imageTextLabel.text = "Copyright: \(copyright)\n\n\(explanation)"
                } else {
                    self.imageTextLabel.text = "\(explanation)"
                }
                                
                self.fetchImageFromCurrentInstance()
                
            }
        }
    }
    
    //MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.ViewControllers.CentralVC.bgColor
        title = AppConstants.ViewControllers.CentralVC.title
        self.navigationController?.navigationBar.prefersLargeTitles = AppConstants.ViewControllers.CentralVC.largeTitles
                       
        CAVProgressHud.sharedInstance.show(withTitle: "Loading data from NASA...")
        
        setUpNasaLogoImage()
        fetchInstanceOfTheDayWithNetworkingManager()
    }
    
    func fetchImageFromCurrentInstance() {
        guard currentAPOD?.media_type == "image",
              let url = //currentAPOD?.hdurl ??
                currentAPOD?.url
        else { return }
        
        //debug
        if AppConstants.debug { print(#function, "trying get image ", String(describing: currentAPOD?.date), " from: ", url) }
        
        imageView.loadImageFromURL(imageUrlString: url)
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
            self.imageNameLabel.text = "\nTry pull to refresh"
            return
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @objc func callPullToRefresh() {
        CAVProgressHud.sharedInstance.show(withTitle: "Loading data from NASA...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 ){
            self.imageTextScrollingView.refreshControl?.endRefreshing()
            self.fetchInstanceOfTheDayWithNetworkingManager()
        }
        if imageTextScrollingView.refreshControl?.isRefreshing == true {
            self.imageNameLabel.text = "\nRefreshing...\n"
        }
    }
    
    private func setUpNasaLogoImage() {
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        view.addSubview(imageNameLabel)
        imageNameLabel.translatesAutoresizingMaskIntoConstraints = false
        imageNameLabel.textAlignment = .center
        imageNameLabel.numberOfLines = 3
        imageNameLabel.text = "Astronomy Picture Of the Day\nbased on public NASA API\nby Andrew, 2022"

        view.addSubview(imageTextScrollingView)
        imageTextScrollingView.translatesAutoresizingMaskIntoConstraints = false
        
        imageTextScrollingView.refreshControl = UIRefreshControl()
        imageTextScrollingView.refreshControl?.addTarget(self,
                                                action: #selector(callPullToRefresh),
                                                for: .valueChanged)
        
        imageTextScrollingView.addSubview(imageTextLabel)
        imageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        imageTextLabel.textAlignment = .center
        imageTextLabel.numberOfLines = 100
        imageTextLabel.text = "About image..."
                
        NSLayoutConstraint.activate([
           
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 6/10),
            
            imageNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            imageNameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageNameLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 2/3),
            
            imageTextScrollingView.topAnchor.constraint(equalTo: imageNameLabel.bottomAnchor),
            imageTextScrollingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageTextScrollingView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageTextScrollingView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            imageTextLabel.topAnchor.constraint(equalTo: imageTextScrollingView.topAnchor),
            imageTextLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 9/10),
            imageTextLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageTextLabel.bottomAnchor.constraint(equalTo: imageTextScrollingView.bottomAnchor),
 
        ])
    }
}

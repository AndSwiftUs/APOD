import UIKit

class CentralViewController: UIViewController {
    
    private let scrollingView = UIScrollView()
    private let imageView = UIImageView()
    private let imageLabel = UILabel()
    private let networkingManager = NetworkingManager()
    
    private var currentAPOD:APOD? = nil {
        didSet {
            DispatchQueue.main.async {
                guard let title = self.currentAPOD?.title,
                      let url = self.currentAPOD?.url,
                      let explanation = self.currentAPOD?.explanation
                else { return }
                        
                let copyright = (self.currentAPOD?.copyright != nil) ? "Copyright: \(String(describing: self.currentAPOD?.copyright))" : ""
                
                self.imageLabel.text = "\(title)\n\(copyright)\n\(url)\n\(explanation)"
                
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
            self.imageLabel.text = "\nTry pull to refresh"
            return
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @objc func callPullToRefresh() {
        CAVProgressHud.sharedInstance.show(withTitle: "Loading data from NASA...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 ){
            self.scrollingView.refreshControl?.endRefreshing()
            self.fetchInstanceOfTheDayWithNetworkingManager()
            
        }
        if scrollingView.refreshControl?.isRefreshing == true {
            self.imageLabel.text = "\nRefreshing...\n"
        }
    }
    
    private func setUpNasaLogoImage() {
        
        view.addSubview(scrollingView)
        scrollingView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollingView.refreshControl = UIRefreshControl()
        scrollingView.refreshControl?.addTarget(self,
                                                action: #selector(callPullToRefresh),
                                                for: .valueChanged)
        
        scrollingView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        scrollingView.addSubview(imageLabel)
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.textAlignment = .center
        imageLabel.numberOfLines = 25
        imageLabel.text = "Astronomy Picture Of the Day\nbased on public NASA API\nby Andrew, 2022"
        
        NSLayoutConstraint.activate([
            scrollingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollingView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollingView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollingView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollingView.heightAnchor, multiplier: 6/10),
            
            imageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            imageLabel.centerXAnchor.constraint(equalTo: scrollingView.centerXAnchor),
            imageLabel.widthAnchor.constraint(equalTo: scrollingView.widthAnchor, multiplier: 2/3),
        ])
    }
}

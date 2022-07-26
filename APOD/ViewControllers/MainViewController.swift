import UIKit

class MainViewController: UIViewController {
    
    private let imageView   = UIImageView()
    private let imageLabel  = UILabel()
    private let loginButton = UIButton()
    
    let storageManager = MainStorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        
        setUpNasaLogoImage()
        setUpLoginButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func didTapLoginButton() {
        let tabBarVC = UITabBarController()
        
        let vc1 = UINavigationController(rootViewController: SearchViewController(storageManager: storageManager))
        let vc2 = UINavigationController(rootViewController: FavouritesViewController()) //storageManager: storageManager))
        let vc3 = UINavigationController(rootViewController: CentralViewController(storeManager: storageManager))
        let vc4 = UINavigationController(rootViewController: AboutViewController())
        let vc5 = UINavigationController(rootViewController: SettingsViewController())
        
        vc1.title = AppConstants.ViewControllers.SearchVC.title
        vc2.title = AppConstants.ViewControllers.FavouritesVC.title
        vc3.title = AppConstants.ViewControllers.CentralVC.title
        vc4.title = AppConstants.ViewControllers.AboutVC.title
        vc5.title = AppConstants.ViewControllers.SettingsVC.title
        
        tabBarVC.setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
        
        guard let items = tabBarVC.tabBar.items else { return }
        let images = [
            AppConstants.ViewControllers.SearchVC.image,
            AppConstants.ViewControllers.FavouritesVC.image,
            AppConstants.ViewControllers.CentralVC.image,
            AppConstants.ViewControllers.AboutVC.image,
            AppConstants.ViewControllers.SettingsVC.image
        ]
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
        }
        
        // делаем текущим 3й вью
        tabBarVC.selectedIndex = 2
        if AppConstants.debug { tabBarVC.selectedIndex = 0 }
        
        tabBarVC.modalPresentationStyle = .fullScreen
        
        present(tabBarVC, animated: false)
    }
    
    private func setUpNasaLogoImage() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "nasa-logo")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        view.addSubview(imageLabel)
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.textAlignment = .center
        imageLabel.numberOfLines = 3
        imageLabel.text = "Astronomy Picture Of the Day\nbased on public NASA API\nby Andrew, 2022."
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 6/10),
            
            imageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            imageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/3),
        ])
    }
    
    private func setUpLoginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.setTitle("Go!", for: .normal)
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = 5.0
        loginButton.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: imageLabel.bottomAnchor, constant: 32),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/3),
        ])
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
}

import UIKit
import Combine

class ZoomableDetailViewController: UIViewController {
    
    private var apodInstance: APODInstance?
    
    private var menuItems: [UIAction] {
        return [
            UIAction(title: "Add to Favourites",
                     image: UIImage(systemName: "star.fill"),
                     attributes: .disabled,
                     handler: { (_) in
                     }),
            UIAction(title: "Save to PhotoAlbum",
                     image: UIImage(systemName: "square.and.arrow.down.fill"),
                     handler: { [weak self] _ in
                         guard let self = self else { return }
                         guard let apodImage = self.apodInstance?.imageData else { return }
                         guard let image = UIImage(data: apodImage) else { return }
                         UIImageWriteToSavedPhotosAlbum(image,
                                                        self,
                                                        #selector(self.image(_:didFinishSavingWithError:contextInfo:)),
                                                        nil)
                     }),
            UIAction(title: "Remove from Favourites",
                     image: UIImage(systemName: "trash"),
                     attributes: .destructive,
                     handler: { [weak self] _ in
                         guard let self = self,
                               let apodInstance = self.apodInstance
                         else { return }
                         
                         MainStorageManager.shared.deleteItem(with: apodInstance)
                         
                         self.navigationController?.popViewController(animated: true)
                     })
        ]
    }
    
    var demoMenu: UIMenu {
        return UIMenu(title: "...", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    private lazy var contentView = APODView()
    
    init(apodInstance: APODInstance) {
        super.init(nibName: nil, bundle: nil)
        self.apodInstance = apodInstance
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...",
                                                            image: nil,
                                                            primaryAction: nil,
                                                            menu: demoMenu)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppConstants.ViewControllers.SearchVC.bgColor
        contentView.imageNameLabel.text = apodInstance?.title
        contentView.imageTextLabel.text = apodInstance?.explanation
        contentView.imageView.image = UIImage(data: (apodInstance?.imageData)!)
    }
    
    // UIImageWriteToSavedPhotosAlbum
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

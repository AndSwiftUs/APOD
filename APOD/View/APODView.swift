import UIKit

final class APODView: UIView {

    lazy var imageView = UIImageView()
    lazy var imageNameLabel = UILabel()
    lazy var imageTextScrollingView = UIScrollView()
    lazy var imageTextLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        let subviews = [imageView, imageNameLabel, imageTextScrollingView, imageTextLabel]
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setUpViews() {
        
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        imageNameLabel.textAlignment = .center
        imageNameLabel.adjustsFontSizeToFitWidth = true
        imageNameLabel.numberOfLines = 2
        imageNameLabel.font = UIFont.boldSystemFont(ofSize: 18)

        imageNameLabel.clipsToBounds = true
        imageNameLabel.layer.cornerRadius = 4
        
        imageTextScrollingView.addSubview(imageTextLabel)
        imageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        imageTextLabel.textAlignment = .center
        imageTextLabel.numberOfLines = 100
        imageTextLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([

            imageNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageNameLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            imageNameLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 8/10),
            
            imageView.topAnchor.constraint(equalTo: imageNameLabel.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 6/10),
            
            imageTextScrollingView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            imageTextScrollingView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            imageTextScrollingView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            imageTextScrollingView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            
            imageTextLabel.topAnchor.constraint(equalTo: imageTextScrollingView.topAnchor),
            imageTextLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 9/10),
            imageTextLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            imageTextLabel.bottomAnchor.constraint(equalTo: imageTextScrollingView.bottomAnchor),
 
        ])
    }
}

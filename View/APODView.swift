import UIKit

final class APODView: UIView {
    
    lazy var pageScrollingView = UIScrollView()
    lazy var imageNameLabel = UILabel()
    lazy var zoomView = UIScrollView()
    lazy var imageView = UIImageView()
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
                
        addSubview(imageNameLabel)
        imageNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(pageScrollingView)
        pageScrollingView.translatesAutoresizingMaskIntoConstraints = false
        
        pageScrollingView.addSubview(zoomView)
        zoomView.translatesAutoresizingMaskIntoConstraints = false
        
        zoomView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        pageScrollingView.addSubview(imageTextLabel)
        imageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func setUpViews() {
                        
        imageNameLabel.textAlignment = .center
        imageNameLabel.adjustsFontSizeToFitWidth = true
        imageNameLabel.numberOfLines = 1
        imageNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        imageNameLabel.clipsToBounds = true
        imageNameLabel.layer.cornerRadius = 4
        
        zoomView.minimumZoomScale = 0.5
        zoomView.maximumZoomScale = 3
        zoomView.showsHorizontalScrollIndicator = false
        zoomView.showsVerticalScrollIndicator = false
        zoomView.delegate = self
        zoomView.isUserInteractionEnabled = true
        zoomView.layer.cornerRadius = 8
                
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        imageTextLabel.textAlignment = .center
        imageTextLabel.numberOfLines = 100
        imageTextLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        zoomView.addGestureRecognizer(doubleTapRecognizer)
    }
    
    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if zoomView.zoomScale == 1 {
            zoomView.setZoomScale(3, animated: true)
        } else {
            zoomView.setZoomScale(1, animated: true)
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            
            imageNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageNameLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -AppConstants.defaultPadding),
            
            pageScrollingView.topAnchor.constraint(equalTo: imageNameLabel.bottomAnchor),
            pageScrollingView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            pageScrollingView.widthAnchor.constraint(equalTo: widthAnchor),
            pageScrollingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageScrollingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            zoomView.topAnchor.constraint(equalTo: pageScrollingView.topAnchor),
            zoomView.centerXAnchor.constraint(equalTo: pageScrollingView.centerXAnchor),
            zoomView.widthAnchor.constraint(equalTo: widthAnchor, constant: -AppConstants.defaultThinPadding),
            zoomView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 7/10),
            
            imageView.topAnchor.constraint(equalTo: zoomView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: zoomView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 7/10),
            
            imageTextLabel.topAnchor.constraint(equalTo: zoomView.bottomAnchor, constant: AppConstants.defaultThinPadding),
            imageTextLabel.widthAnchor.constraint(equalTo: pageScrollingView.widthAnchor, multiplier: 9/10),
            imageTextLabel.centerXAnchor.constraint(equalTo: pageScrollingView.centerXAnchor),
            imageTextLabel.bottomAnchor.constraint(equalTo: pageScrollingView.bottomAnchor),
            
        ])
    }
}

extension APODView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
